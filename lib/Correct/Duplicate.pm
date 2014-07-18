use strict;
use warnings;
package Correct::Duplicate;

sub suggestions {
  my $string = shift;
    my @matches = ();
    my $last_index = 0;
    my $last_diff = 0;
    my $handle = sub {
      my $character = shift;
      my $index = shift;
      my $index_end = shift;
      my $diff = $index_end - $index;
      $last_index = $last_index + 1 + ($index - $last_diff);
      $last_diff += $diff;  
      push @matches, {"loc" => $last_index -1, "chr" => $character};
      return $character;
    };

  $string =~ s/(\w)(\1+)/$handle->($1, $-[0], $+[0])/eg;
  my @suggestions = ($string);
    foreach my $m (@matches) {
       foreach my $len (2..3) {
           my $dups = $m->{chr};
            $dups = $dups x $len;
          my $s = $string;
          substr($s, $m->{loc}, 1, $dups);
           push @suggestions, $s;
       }
    }
  return @suggestions;
}


1;
