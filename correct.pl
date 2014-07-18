use strict;
use warnings;
use lib 'lib';
use Tree::RedBlack;
use Correct::Vowels;
use Correct::Duplicate;

#Create a redblack tree
my $t = Tree::RedBlack->new();
print STDERR  "Loading dictionary ...";
#Load the words into a redblack tree
my @words = loadDict($t);
print STDERR "Ready \n";

#Create a comparator that ignores case by converting both words to lowercase
$t->cmp(sub {  
        my $lc_a = lc(shift);       
       my $lc_b = lc(shift);
       chomp($lc_b);
       my $cmp = $lc_a cmp $lc_b;
       return $cmp;
});

#Check if we are piping data 
unless (-t STDIN and not @ARGV ) {
    my @pipedWords = split(' ',<STDIN>);
    foreach my $word (@pipedWords) {
       print "Incorrect Word: $word \n";
       print "Suggestion: " . suggestAndSearch($word) . "\n";
    }
  exit;
}

#Loop for input
while (1) {
  # get stdin from prompt
  print ">";
  my $control = <>;
  # remove and new line characters
  chomp($control);
  # Search for a suggestion
  print suggestAndSearch($control) . "\n";
}

#Build Suggestions and search for them in the tree
sub suggestAndSearch {
  my $word = lc(shift);
  #Get vowel suggestions and dupliciated word suggestions
  my @vowel_suggestions = Correct::Vowels::suggestions($word); 
  my @duplicate_suggestions = Correct::Duplicate::suggestions($word); 
  my @suggestions = (@vowel_suggestions, @duplicate_suggestions);
  #for each suggession see if we can find a word 
  #if we do then return it
  foreach my $suggested (@suggestions) {
        next unless $suggested;
     my $found = $t->find($suggested);
     next unless $found;
     return $found;
  }
  return 'NO SUGGESTIONS';

}


#Load the file and insert the words into a redblack tree
sub loadDict {
    my $tree = shift;
    my $dict = 'words';
    open my $dictFH, "<$dict" or die;
    my @words = <$dictFH>;
    close $dictFH;
    foreach my $word (@words) {
        chomp($word);
        $tree->insert($word, $word);
    }
    return @words;
}

