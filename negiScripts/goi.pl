#!usr/bin/perl
use LWP::UserAgent;
use strict;
use warnings;
use YahooFuriganaParser;
use GoiCard;
use open qw( :utf8 :std );
use utf8;

$|++;


genAnkiCsv();
#nain();

# call: script <inputfile> <grade>
sub genAnkiCsv{
	my ($fileName, $grade) = @ARGV;	
	die "hard" unless defined $fileName;
	$grade = 3 unless defined $grade;
	#validate input;
	print "input:$fileName, grade:$grade\n";
	readAkebiCsv($fileName, $grade);

}

sub readAkebiCsv{
	my $fileName = shift;
	my $grade = shift;
	open my $get, "<", $fileName;
	open my $yaz, ">", "anki.txt"; ## TODO: outputfile --> parameter;
	#my ($word, $meaningLine) = ("","");
	while( defined(my $word = <$get>) and defined(my $meaningLine = <$get>)){
		# $word = japanese field
		# $meaningHtml = html code for the list
		chomp($word, $meaningLine);
		print "$word\n";
		my $meaningHtml = meaningLineToHtml($meaningLine);
		# print "$word\n";
		# print $meaningHtml;
		# print "\n--------------------------\n";
		my $furiganaHtml = YahooFuriganaParser::getFuriHtml($word,$grade);
		my $goiCard = new GoiCard($word, $meaningHtml, $furiganaHtml);
		$goiCard->printAnkiCsvLine($yaz, ";"); ## TODO: delimiter --> parameter;
	}
}

sub meaningLineToHtml{
	my $meaningLine = shift;
	my @meaningList = split /; /, $meaningLine;
	my $html = '<div id="meaningList"><ol>';
	$html .= "<li><p>$_</p></li>" foreach @meaningList;
	$html .= "</ol></div>";
	return $html;
}