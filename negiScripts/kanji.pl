#!/usr/bin/perl
use LWP::Simple;
use strict;
use warnings;
use open qw( :utf8 :std );
use utf8;
use YahooFuriganaParser;

$|++;

# listlesstan alip csv txt'nin icine koyuyo, aklinda bulunsun.
#for regex matches.
our $BLOCK = "<div class=\"concept_light clearfix\">";	
our $HEADER = "<h4>Words<span class=\"result_count\"> . (\\d+) found<\\/span><\\/h4>";
our $FURIGANA = "<span class=\"kanji-\\d-up kanji\">(.*?)<\\/span>";
our $MEANING  = ""; #TODO
our $JUKUGO_OFFSET = 3;
our $MEANING_OFFSET= 15;
our $jukugo_offset_LINE = "<span class=\"text\">";
our $meaning_offset_LINE = "meanings-wrapper";

main();

sub main{
	my ($fileName, $grade) = @ARGV;	
	die "hard" unless defined $fileName;
	$grade = 1 unless defined $grade; ## <-- REFACTOR STUFF.
	#validate input;
	print "input:$fileName, grade:$grade\n";

	my ($numberOfKanji, $csvLine) = (0, "");
	my (@lines, @csvLines);
	open my $get, "<", $fileName;
	while(<$get>){
		chomp ;
		push(@lines, $_);
		++$numberOfKanji unless($_ =~ /^\t/);
	}
	close $get;
	@lines = reverse @lines;

	# print "$numberOfKanji\n";
	# print "$_\n" foreach @lines;

	for (my $i=0 ; $i<$numberOfKanji ; ++$i){
	 	my $csvLine = generate_csv_line(\@lines);
	 	push(@csvLines, $csvLine);
	}

	open (my $out, ">anki.txt");
	print $out "$_\n" foreach @csvLines;
	#close $out;
}

# TODO ERROR CHECKING
sub generate_csv_line{
	my $_lines = shift;
	my $kanji = pop @$_lines;
	my @examples;
	while(defined(@$_lines[-1]) and @$_lines[-1] =~ /\t/){
		my $ex = pop @$_lines;
		$ex =~ s/\t//;
		push(@examples, $ex);
	}
	# -- kanji;meanings;onYomi;kunYomi
	my $csvLine = get_kanji_content($kanji);
	# this part is in html format.
	my $csvWordList = ';<div><ul style="list-style-type:none">';
	foreach my $ex (@examples) {
		$csvWordList .= gen_li_html($ex);
	}
	$csvWordList .= '</ul></div>';
	$csvLine .= $csvWordList
}

sub gen_li_html{
	my $exampleLine = shift;
	print "working on --> $exampleLine ...\n";
	my ($jukugo, $meaning) = split(/: /, $exampleLine);
	my $jukugoWithFuri = YahooFuriganaParser::getFuriHtml($jukugo,1);
	my $li_html =
		"    <li>" .
		"        <listkana>    "   .$jukugoWithFuri .   ":   </listkana>" .
		"        <listroma>    "   .$meaning        .   "    </listroma>" .
		"    </il>";
	return $li_html;

}
# -- kanji;meanings;onYomi;kunYomi
sub get_kanji_content{
	my $kanji = shift;
	print "getting kanji content on --> $kanji...\n";
	my $url = "http://jisho.org/search/$kanji\%23kanji";
	my $sauce = get($url) or die "$url --> sauce b hard to get.\n";

	### get meaning
	my $meaningRgx = '<div class="kanji-details__main-meanings">$' .  	
					 	'\s*(.*?)$' .									
					 '\s*<\/div>';										
	my $meaningLine;
	if( $sauce =~ /$meaningRgx/m){
		$meaningLine = $1;
	}

	#get kunyomi
	my $kunyomiRgx ='<dl class="dictionary_entry kun_yomi">$' .
						'\s*<dt>Kun:<\/dt>$' .
				 		'\s*<dd class="kanji-details__main-readings-list" lang="ja">$'.
				 			'\s*((<a href=".*?">.*?<\/a>(&#12289;)?)+)$' .
				 		'\s*<\/dd>$' .
				 	'\s+<\/dl>';	
	my @kunyomiList;
	if( $sauce =~ /$kunyomiRgx/mg){
		@kunyomiList = ( $1 =~ /<a href=".*?">(.*?)<\/a>/g);
	}

	#get onyomi
	my $onyomiRgx = '<dl class="dictionary_entry on_yomi">$' .
						'\s*<dt>On:<\/dt>$' .
				 		'\s*<dd class="kanji-details__main-readings-list" lang="ja">$'.
				 			'\s*((<a href=".*?">.*?<\/a>(&#12289;)?)+)$' .
				 		'\s*<\/dd>$' .
				 	'\s+<\/dl>';	
	my @onyomiList;
	if( $sauce =~ /$onyomiRgx/mg){
		@onyomiList = ( $1 =~ /<a href=".*?">(.*?)<\/a>/g);
	}

	# start creating a csv line. 
	my $csvLine = "$kanji;"; 						# --> kanji;
	$csvLine .= "$meaningLine;";					# --> kanji;meanings;

	unless ($#onyomiList == -1){
		$csvLine .= shift @onyomiList;
		$csvLine .= "\&\#12289$_"  foreach @onyomiList;  
	}

	$csvLine .= ";";
	unless ($#kunyomiList == -1){
		$csvLine .= shift @kunyomiList;
		$csvLine .= "\&\#12289$_"  foreach @kunyomiList;  
	}
	

	
	# -- kanji;meanings;onYomi;kunYomi
	return $csvLine;
}

sub leftTrim{my $str = shift;$str =~ s/^\s*//;return $str;}