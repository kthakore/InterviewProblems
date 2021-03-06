##PROBLEM

Write a program that reads a large list of English words (e.g. from /usr/share/dict/words on a unix system) into memory, and then reads words from stdin, and prints either the best spelling suggestion, or "NO SUGGESTION" if no suggestion can be found. The program should print "> " as a prompt before reading each word, and should loop until killed.

Your solution should be faster than O(n) per word checked, where n is the length of the dictionary. That is to say, you can't scan the dictionary every time you want to spellcheck a word.

For example:
 > sheeeeep
 sheep
 > peepple
 people
 > sheeple
 NO SUGGESTION

The class of spelling mistakes to be corrected is as follows:

Case (upper/lower) errors:
 "inSIDE" => "inside"

Repeated letters:
 "jjoobbb" => "job"

Incorrect vowels:
 "weke" => "wake"

In addition, any combination of the above types of error in a single word should be corrected (e.g. "CUNsperrICY" => "conspiracy").

If there are many possible corrections of an input word, your program can choose one in any way you like, however your results *must* match the examples above (e.g. "sheeeeep" should return "sheep" and not "shap").

Final step: Write a second program that generates words with spelling mistakes of the above form, starting with correctly spelled English words. Pipe its output into the first program and verify that there are no occurrences of "NO SUGGESTION" in the output.

##SOLUTION
Disqus coding challenge.

I used perl 5.14 to implement the code (I chose this language due to the power regular expressions features). I also used a RedBlack tree library from CPAN (which I have included in the lib/Tree/ folder). I chose this structure so that I wouldn't have to rescan the document and also due to the following wikipedia article:

https://en.wikipedia.org/wiki/Binary_search_tree#Performance_comparisons

My approach was to generate suggestions based on the input and the search for the variations on the word. 

To solve the problem of uppercase error. I just lowercase'd the input and all the words in the dictionary before storing in the redblack tree.

The classes of error suggestions were implemented using the powerful regular expressions in perl. More detailed comments are included in the files below. 

1. Vowel replacement: lib/Correct/Vowel.pm
1. Duplicates: lib/Correct/Duplicate.pm

To run the prompt please do:

$ perl correct.pl

Incorrect word generation 

I used a dispatch to randomly select between the three errors.

To run the incorrect.pl 

$ perl incorrect.pl

$ perl incorrect.pl | perl correct.pl
