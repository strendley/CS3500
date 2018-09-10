/*
Programmer: Skylar Trendley
Professor: Leopold
Description: Program acts as a lexicon and token processor*/

%{
/* 
Definitions of constants, variables, & function prototypes go here 
*/

#define T_IDENT     1
#define T_INTCONST  2
#define T_UNKNOWN   3
#define T_STRCONST  4

int numLines = 0;

void printTokenInfo(const char* tokenType, char* lexeme);

%}

/* Definitions of regular expressions go here */

WSPACE		[ \t\v\r]+
NEWLINE          \n
COMMENT 	;.*

DIGIT	           [0-9]
LETTER           [a-zA-Z]
UNDERSCORE       [_]

IDENT			{LETTER}*|({LETTER}|{DIGIT})*|({UNDERSCORE}{LETTER}*)*
INTCONST        [-+]{DIGIT}*|{DIGIT}*
STRCONST 		\".*\"


%%

"+"         {
				printTokenInfo("ADD", yytext);
				return T_IDENT;
			}
			
"-"         {
				printTokenInfo("SUB", yytext);
				return T_IDENT;
			}

"*"         {
				printTokenInfo("MULT", yytext);
				return T_IDENT;
			}

"/"         {
				printTokenInfo("DIV", yytext);
				return T_IDENT;
			}
			
"/="        {
				printTokenInfo("NE", yytext);
				return T_IDENT;
			}

"<"         {
				printTokenInfo("LT", yytext);
				return T_IDENT;
			}

">"         {
				printTokenInfo("GT", yytext);
				return T_IDENT;
			}

"<="        {
				printTokenInfo("LE", yytext);
				return T_IDENT;
			}

">="        {
				printTokenInfo("GE", yytext);
				return T_IDENT;
			}

"="         {
				printTokenInfo("EQ", yytext);
				return T_IDENT;
			}			
					
			
"("         {
				printTokenInfo("LPAREN", yytext);
				return T_IDENT;
			}
			
")"         {
				printTokenInfo("RPAREN", yytext);
				return T_IDENT;
			}
						

"input"     {
				printTokenInfo("INPUT", yytext);
				return T_IDENT;
			}				
			
			
"if"        {
				printTokenInfo("IF", yytext);
				return T_IDENT;
			}				
			
"let*"      {
				printTokenInfo("LETSTAR", yytext);
				return T_IDENT;
			}
			
"lambda"    {
				printTokenInfo("LAMBDA", yytext);
				return T_IDENT;
			}
			
"print"     {
				printTokenInfo("PRINT", yytext);
				return T_IDENT;
			}

"or"        {
				printTokenInfo("OR", yytext);
				return T_IDENT;
			}
			
"and"        {
				printTokenInfo("AND", yytext);
				return T_IDENT;
			}			

"not"       {
				printTokenInfo("NOT", yytext);
				return T_IDENT;
			}

"t"         {
				printTokenInfo("T", yytext);
				return T_IDENT;
			}

"nil"       {
				printTokenInfo("NIL", yytext);
				return T_IDENT;
			}			
			
	
"foo"       {
				printTokenInfo("FOO", yytext);
				return T_INTCONST;
			}
			
{INTCONST}	{
				printTokenInfo("INTCONST", yytext);
				return T_INTCONST;
			}
			
{STRCONST}	{
				printTokenInfo("STRCONST", yytext);
				return T_STRCONST;
			}			
			
{IDENT}		{
				printTokenInfo("IDENT", yytext);
				return T_IDENT;
			}
			
{NEWLINE}   {
                        numLines++;
            }
			
{WSPACE}		{ }

{COMMENT}	{ 
			}

.			{
				printTokenInfo("UNKNOWN", yytext);
				return T_UNKNOWN;
			}

%%

// User-written code goes here

void printTokenInfo(const char* tokenType, char* lexeme) {
  printf("TOKEN: %s  LEXEME: %s\n", tokenType, lexeme);
}

// You should supply a yywrap function.
// Having it return 1 means only 1 input file will be scanned.
int yywrap(void) { return 1; }

int main(void) {
  while ( yylex() ) ;  // Keep processing tokens until 0 returned

  return 0;
}


