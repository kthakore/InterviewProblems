use strict;
use warnings;
use lib 'lib';
use Correct::Vowels;
use Correct::Duplicate;
my @words = loadDict();

sub loadDict {
    my $dict = 'words';
    open my $dictFH, "<$dict" or die;
    my @words = <$dictFH>;
    close $dictFH;
    return @words;
}

my $len = scalar @words;

my @vowels = qw/a e i o u/;
my $error_generator_dispatch = {
  # Case error
  0  => sub {
    my $word = shift;
    my @characters = split(/|/, $word);
    my $len = length($word);
    # Randomly uc letters
     foreach (1..rand($len)) {
        my $select = int(rand($len));
        $characters[$select] = uc($characters[$select]);
     }
    # Join and send it back 
    return join('', @characters);
  },
  # vowel error
  1 => sub {
    my $word = shift;
    my $len = length($word);
    my $replaced = 0;
    my $handle = sub {
        my $vowel = shift;
        return $vowel if $replaced > 0;
        my $replace = $vowels[int(rand(scalar(@vowels)))];  
        $replaced++ if $vowel ne $replace;
       return $replace;
    };
    $word =~ s/(a|e|i|o|u)/$handle->($1, $-[0])/ge;
    return $word;
  },
  # duplicate errors
  2 => sub {
    my $word = shift;
    my @characters = split(/|/, $word);
    my $len = length($word);
    # Randomly duplicate letters
        my $select = int(rand($len));
        while( $characters[$select] !~ /[a-z]/g ) {
            $select = int(rand($len))
        }
        substr( $word, $select, 1, $characters[$select] x int(rand(2) + 2) );
    # Join and send it back 
    return $word;

  }

};

#foreach(0..10) {
  my $word = $words[int(rand($len))];
  chomp($word);
  warn $word;
  print $error_generator_dispatch->{int(rand(3))}->($word) . " ";
#}


