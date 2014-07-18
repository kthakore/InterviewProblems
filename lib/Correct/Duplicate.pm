use strict;
use warnings;
package Correct::Duplicate;

#Create suggestions 
sub suggestions {
  my $string = shift;
    my @matches = ();
    my $last_index = 0;
    my $last_diff = 0;

    # Create a regex handler that we call on each duplicated character
    # We record the final location of the character in the template (no duplicates
    # string) and store it in a array 
    # of hashes called @matches
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
  # Regex through the string and find duplicated characters, then for each match execute the handle subroutine above
  # We pass in the match $1 and the index of the match $-[0] begins and $+[0] end
  # We are also replacing the duplicate with only one character to create a template ($string)
  # For example: abba => aba 
  $string =~ s/(\w)(\1+)/$handle->($1, $-[0], $+[0])/eg;

  #We then expand each on the matches to duplicates of up to 2-3 characters 
  #4 character duplicates are very rare in english so let's leave them out

  #Store suggestions in an array already containing the template which covers cases such as:
  # doog => dog
  my @suggestions = ($string);
    #Go through each of the matches and expand them 
    foreach my $m (@matches) {
       foreach my $len (2..3) {
            #get the character
           my $dups = $m->{chr};
            # multiply the string
            $dups = $dups x $len;
          my $s = $string;
            #insert it back into the string
          substr($s, $m->{loc}, 1, $dups) unless $m->{loc} > $len;
           push @suggestions, $s;
       }
    }
    #return all of our suggestions
  return @suggestions;
}


1;
