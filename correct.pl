use strict;
use warnings;
use List::BinarySearch qw( binsearch );
use Text::Levenshtein qw(distance);
use Data::Dumper;
use lib 'lib';
use Correct::Vowels;
use Correct::Duplicate;

my $control = '';
my @words = loadDict();


while (1) {
  # get stdin from prompt
  print ">";
  $control = <>;
  chomp($control);
   print buildSuggestions($control) . "\n";
}

sub buildSuggestions {
  my $word = lc(shift);
  my @vowel_suggestions = Correct::Vowels::suggestions($word); 
  my @duplicate_suggestions = Correct::Duplicate::suggestions($word); 
  my @suggestions = (@vowel_suggestions, @duplicate_suggestions);
  my $min_distance = 1000;
  my $foundHash = {};
  my @founds = ();
  foreach my $suggested (@suggestions) {
        next unless $suggested;
     my $found = searchDict($suggested);
     next unless $found;

     my $distance = distance($word, $found) ;
     $min_distance = $distance if ($distance < $min_distance);
     $foundHash->{$distance} = $found;
     push @founds, $found;
  }
  
  return 'NO SUGGESTIONS' unless $foundHash->{$min_distance};
  my $first = $foundHash->{$min_distance} || $founds[0];
  return $first;  

}


sub loadDict {
    my $dict = 'words';
    open my $dictFH, "<$dict" or die;
    my @words = <$dictFH>;
    close $dictFH;
    return @words;
}

sub searchDict {
    my $word = shift;
    return unless $word;
     my $lowest = 6;
  
    my $index = binsearch { 
       my $lc_a = lc($a);       
       my $lc_b = lc($b);
       chomp($lc_b);
       my $cmp = $lc_a cmp $lc_b;
       return $cmp;
	} $word, @words;
     
    return $words[$index] if $index;
}
