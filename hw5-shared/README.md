#To diff ALL files to the expected output, use the command:
#$bash tester.sh

#To diff files individually, use the commands:
#the make file compiles flex's the .l file, bison's the .y file, and compiles the parser 
#$make 
#$parser < inputFileName > myOutput.out
#$diff myOutput.out inputFileName.txt.out --ignore-space-change --side-by-side --ignore-case --ignore-blank-lines
