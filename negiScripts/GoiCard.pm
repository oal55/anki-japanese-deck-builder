use strict;
use warnings;
package GoiCard;

sub new{
	my($class, $japanese, $english, $furigana) = @_; # $_[0] contains the class name
	my $self = {
		japanese => $japanese,
		english  => $english,
		furigana => $furigana,
	};		# make $self an object of class $class
	bless $self, $class;
	return $self;		# a constructor always returns a blessed object
}

sub getJapanese{
	my $self = shift;
	return $self->{japanese};
}

sub getEnglish{
	my $self = shift;
	return $self->{english};
}

sub getFurigana{
	my $self = shift;
	return $self->{furigana};
}

sub printAnkiCsvLine{# (target file's handle, delimiter)
	my $self = shift;
	my $target = shift;
	my $delim = shift;
	my $line = "$self->{japanese}$delim$self->{english}".
			   "$delim$self->{furigana}\n";
	print $target $line;
}

1;