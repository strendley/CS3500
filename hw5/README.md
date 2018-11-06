To diff ALL files to the expected output, use the command:


$bash tester.sh


To diff files individually, use the commands:





$make 


$parser hw5_sample_input/inputFileName.txt > myOutput.out


$diff myOutput.out inputFileName.txt.out --ignore-space-change --side-by-side --ignore-case --ignore-blank-lines


Note: the make file flex's the .l file, bison's the .y file, and compiles the parser 


Note: the files requiring input will not be tested with bash tester.sh, and must be tested individually
