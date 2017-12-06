#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper qw(Dumper);
package YahooFuriganaParser;

# Below grammar is assumed based on trial.
# It's not mentioned in Yahoo Japan!'s documentation.
# Start string = {ResulSet}

# {ResultSet}         ---> <ResulSet xmlns=".*?">{Result}</ResulSet>
# {Result}            ---> <Result>{WordList}</Result>
# {WordList}          ---> <WordList>{Word}{WordListCon}</WordList>
# {WordListCon}       ---> {Word}{WordListCon}
# {WordListCon}       ---> {}
# {Word}              ---> <Word> {Display}{Reading} </Word>
# {Word}              ---> <Word> {Display}{Reading}{SubWordList} </Word>
# {Word}              ---> <Word> {Display} </Word>
# {SubWordList}       ---> <SubWordList>{SubWord}{SubWordListCon}</SubWordList>
# {SubWordListCon}    ---> {SubWord}{SubWordListCon}
# {SubWordListCon}    ---> {}
# {SubWord}           ---> <SubWord>{Display}{Reading}</SubWord>
# {Display}           ---> <Surface>(.*?)</Surface>
# {Reading}           ---> <Furigana>(.*?)</Furigana> 
#                          <Roman>(.*?)</Roman> 


#{CardList}			-->		{Card}{CardListCon}
#{CardListCon} 		-->		{Card}{CardListCon}
#{CardListCon}		-->		{}
#{Card}				-->		(^.*?$)



# Difference between methods and functions:
# Methods get $class parameter at $_[0], and are called like
# $variable->method($stuff).
# Fuctions dont get extra shit, are called like
# PackageName::FunctionName($sfuff...) and they sound more manly.
sub new{
	my($class) = @_; # $_[0] contains the class name
	my $self = {};		# make $self an object of class $class
	bless $self, $class;
	return $self;		# a constructor always returns a blessed object
}

sub getFuriHtml{
	my $sentence = shift;
	my $grade = shift;
	my $url = 'http://jlp.yahooapis.jp/FuriganaService/V1/furigana';
	my $appid = 'dj0zaiZpPWtIQ2ptNjlQN3dMOSZzPWNvbnN1bWVyc2VjcmV0Jng9NTY-';

	my $ua = LWP::UserAgent->new;
	$ua->agent( "Yahoo AppID: $appid" );
	my $response = $ua->post( $url, { 
		'sentence' => $sentence,
		'grade' => $grade } );

	my $responseHtml = $response->decoded_content;
	print $responseHtml;
	return _initHtmlBody($responseHtml);
}

sub _initHtmlBody{
	my $source = shift;
	my @tokens = _dokenize($source);
	# LT GT LERI HTMLE CEVIRDIK
	my $parsed = _parseXml(\@tokens);
	$parsed =~ s/&lt/</g;$parsed =~ s/&gt/>/g;
	return $parsed;
}
# this is not a tokenizer, but a dokenizer for it
# reverses all its shit right before the return statement;
sub _dokenize{
	my $file = shift;
	my @lines = split /\n/,$file;
	my @tokens;
	my $delim = ';';
	foreach (@lines){
		chomp;
		s/\s*//;
		s/(<\w*?>)/$1$delim/;   					#put delim after opening tags
		s/(<\/\w*?>)/$delim$1/ unless /^<\/\w*?>$/; #put delim bfore closing tags		
		push @tokens, split/$delim/;
	}
	@tokens = reverse @tokens;
	#print "$_\n" foreach @tokens;	
	return @tokens;
}


sub _parseXml{
	my $_tokens = shift;
	pop @$_tokens until(@$_tokens[-1] =~ /<ResultSet.*?>/);
	return _ResultSet($_tokens);
}

sub _ResultSet{
	my $_tokens = shift;
	
	# pop <ResultSet>
	die "sictik ResultSet in\n" unless(@$_tokens[-1] =~ /<ResultSet.*?>/);
	pop @$_tokens;

	# pop everything in between
	return _Result($_tokens);
	
	# pop </ResultSet>
	die "sictik ResultSet out\n" unless(@$_tokens[-1] eq '</ResultSet>');
	pop @$_tokens;
}

sub _Result{
	my $_tokens = shift;
	
	# pop <Result>
	die "sictik Result in\n" unless(@$_tokens[-1] eq '<Result>');
	pop @$_tokens;

	# pop everything in between
	return _WordList($_tokens);
	
	# pop <Result>
	die "sictik Result out\n" unless(@$_tokens[-1] eq '</Result>');
	pop @$_tokens;	
}


sub _WordList{
	my $_tokens = shift;
	
	# pop <WordList>
	die "sictik WordList in\n" unless(@$_tokens[-1] eq '<WordList>');
	pop @$_tokens;
	
	# pop the first word, and the rest of the list recursively
	my $head = _Word($_tokens);
	my $tail = _WordListCon($_tokens);

	# pop <WordList>
	die "sictik WordList out\n" unless(@$_tokens[-1] eq '</WordList>');	
	pop @$_tokens;		

	return $head . $tail;
}

sub _Word{
	my $_tokens = shift;
	my ($display, $fullReading, $furiHtml) = ("","","");
	
	#pop <Word>
	die "sictik Word in\n"	unless(@$_tokens[-1] eq '<Word>');
	pop @$_tokens;

	#pop everything in between 
	$display = _Display($_tokens);
	my $sentenceBody = "$display";
 	if(@$_tokens[-1] eq '<Furigana>'){
 		$fullReading = _Reading($_tokens);
 		$sentenceBody = "<ruby>$display<rt>$fullReading</rt></ruby>"	
 	}
	#if there's a subword list, take whatever it returns instead.
	$sentenceBody = _SubWordList($_tokens) if(@$_tokens[-1] eq '<SubWordList>');

	#pop </Word>
	die "sictik Word out\n" unless(@$_tokens[-1] eq '</Word>');	
	pop @$_tokens;

	return $sentenceBody
}

sub _WordListCon{
	my $_tokens = shift;
	#empty case
	return "" if @$_tokens[-1] eq '</WordList>';
	my $curBody = _Word($_tokens);
	return $curBody . _WordListCon($_tokens);
}

sub _SubWordList{
	my $_tokens = shift;
	
	die "sictik SubWordList in\n" unless(@$_tokens[-1] eq '<SubWordList>');
	pop @$_tokens;
	
	my $head = _SubWord($_tokens);
	my $tail = _SubWordListCon($_tokens);

	die "sictik SubWordList out\n" unless(@$_tokens[-1] eq '</SubWordList>');	
	pop @$_tokens;		

	return $head . $tail;
 }

sub _SubWord{
	my $_tokens = shift;
	my ($display, $reading) = ("","");
	
	die "sictik SubWord in\n"	unless(@$_tokens[-1] eq '<SubWord>');
	pop @$_tokens;

	$display = _Display($_tokens);
 	$reading = _Reading($_tokens);
 	$reading = "" unless($display =~ /\p{Han}/);
	my $sentenceBody = $display;
	if ($display =~ /\p{Han}/){
		$sentenceBody = "<ruby>$display<rt>$reading</rt></ruby>" ;
	}

	die "sictik SubWord out\n" unless(@$_tokens[-1] eq '</SubWord>');	
	pop @$_tokens;

	return $sentenceBody
}

sub _SubWordListCon{
	my $_tokens = shift;
	#empty case
	return "" if @$_tokens[-1] eq '</SubWordList>';
	my $curBody = _SubWord($_tokens);
	return $curBody . _SubWordListCon($_tokens);
}

sub _Display{
	my $_tokens = shift;

	die "sictik Display in\n" unless(@$_tokens[-1] eq '<Surface>');
	pop @$_tokens;
	
	my $display = "";
	until(@$_tokens[-1] eq '</Surface>'){
		$display .= pop @$_tokens;
	}

	die "sictik D-out:$display\n" unless(@$_tokens[-1] eq '</Surface>');	
	pop @$_tokens;

	return $display;
}

sub _Reading{
	my $_tokens = shift;

	# pop <Furigana>
	die "sictik Reading Furigana in\n" unless(@$_tokens[-1] eq '<Furigana>');
	pop @$_tokens;

	# kana reading
	my $readingFurigana = pop @$_tokens;
	
	# pop </Furigana>
	die "sictik Reading Furigana out\n" unless(@$_tokens[-1] eq '</Furigana>');	
	pop @$_tokens;

	# pop <Roman>
	die "sictik Reading Roman in\n" unless(@$_tokens[-1] eq '<Roman>');
	pop @$_tokens;

	# trash
	my $readingRomaji = pop @$_tokens;
	
	# pop </Roman>
	die "sictik Reading Roman out\n" unless(@$_tokens[-1] eq '</Roman>');	
	pop @$_tokens;

	return $readingFurigana;	
}


1;