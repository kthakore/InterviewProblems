use strict;
use warnings;
package Correct::Vowels;

my @vowels = qw/a e i o u/;
my $vowelsreg = 'a|e|i|o|u';

# Search for vowels and replace them all other vowels
# NOTE: To make this efficent we could us a probabilty 
# of prior constants and mostly vowels after by pre parsing the dictionary
sub suggestions {
    my $word = shift;
    my @suggestions = ();
    # Create a regex handler that we call on each vowel
    my $handle = sub {
        my $character = shift;
        my $index = shift;
       #we then create strings while replacing each on of the vowels
       #with alternative vowels
        foreach my $v (@vowels) {
            my $w = $word;
            substr($w, $index, 1, $v) unless $character eq $v;
            push @suggestions, $w;
        }
        return $character;
    };
    #searching through the string for all instances of hte vowels
    #QUESTION: Are accented e considered vowels? 
    $word =~ s/(a|e|i|o|u)/$handle->($1, $-[0])/eg;
    return @suggestions;
}

1;
