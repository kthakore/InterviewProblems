use strict;
use warnings;
package Correct::Vowels;

my @vowels = qw/a e i o u/;
my $vowelsreg = 'a|e|i|o|u';


sub suggestions {
 my $word = shift;
  my @suggestions = ();
my $handle = sub {
   my $character = shift;
    my $index = shift;
   foreach my $v (@vowels) {
      my $w = $word;
      substr($w, $index, 1, $v) unless $character eq $v;
      push @suggestions, $w;
   }
   return $character;
};

$word =~ s/(a|e|i|o|u)/$handle->($1, $-[0])/eg;
 return @suggestions;
}

1;
