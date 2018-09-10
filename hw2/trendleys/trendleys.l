/*
Programmer: Skylar Trendley
Professor: Leopold
Description: Program acts as a lexicon and token processor
*/

%{

/* 
Definitions of constants, variables, & function prototypes go here 
*/

%}

/* Definitions of regular expressions go here */
WSPACE		[ \t\v\r]+
NEWLINE 	\n
LO_ALPHA		[a-z]
HI_ALPHA		[A-Z]
ALPHA			{LO_ALPHA}|{HI_ALPHA}
DIGIT            [0-9]
ALPHANUM		{ALPHA}|{DIGIT}
UNDERSCORE		_

IDENT			({UNDERSCORE}|{ALPHA})({ALPHANUM}|{UNDERSCORE})*

NEG_INTCONST	"-"[0-9]+
POS_INTCONST	("+")?[0-9]+
INTCONST        {NEG_INTCONST}|{POS_INTCONST}

DOUBLE_QUOTE      \"
STRCONST         {DOUBLE_QUOTE}[^\"\n]*{DOUBLE_QUOTE} 

COMMENT           ";".*$    


T_SUB		-
T_ADD		\+
T_MULT		\*
T_DIV		\/
T_OR		or
T_NOT		not
T_AND		(and)
T_LT		<
T_GT		>
T_LE		<=
T_GE		>=
T_EQ		=
T_NE		\/=
T_LPAREN	\(
T_RPAREN	\)
T_LETSTAR	let\*
T_IF		if
T_LAMBDA	lambda		
T_PRINT		print
T_INPUT		input
T_T			t
T_NIL		nil  
/*
 *	Tokens
*/
%%

{T_LPAREN}	{
			printTokenInfo("LPAREN", yytext);
			return T_LPAREN;
			}
			
{T_RPAREN}	{
			printf("TOKEN: RPAREN    LEXEME: %s\n", yytext);
			return T_RPAREN;
			}
			
{T_ADD}		{
			printf("TOKEN: ADD       LEXEME: %s\n", yytext);
			return T_ADD;
			}
			
{T_SUB}		{
			printf("TOKEN: SUB       LEXEME: %s\n", yytext);
			return T_SUB;
			}
			
{T_MULT}	{
			printf("TOKEN: MULT      LEXEME: %s\n", yytext);
			return T_MULT;
			}
			
{T_DIV}		{
			printf("TOKEN: DIV       LEXEME: %s\n", yytext);
			return T_DIV;
			}
			
{T_GT}		{
			printf("TOKEN: GT        LEXEME: %s\n", yytext);
			return T_GT;
			}
			
{T_GE}		{
			printf("TOKEN: GE        LEXEME: %s\n", yytext);
			return T_GE;
			}
			
{T_LT}		{
			printf("TOKEN: LT        LEXEME: %s\n", yytext);
			return T_LT;
			}
			
{T_LE}		{
			printf("TOKEN: LE        LEXEME: %s\n", yytext);
			return T_LE;
			}
			
{T_EQ}		{
			printf("TOKEN: EQ        LEXEME: %s\n", yytext);
			return T_EQ;
			}
			
{T_NE}		{
			printf("TOKEN: NE        LEXEME: %s\n", yytext);
			return T_NE;
			}
			
{T_LETSTAR}	{
			printf("TOKEN: LETSTAR   LEXEME: %s\n", yytext);
			return T_LETSTAR;
			}
			
{T_IF}		{
			printf("TOKEN: IF        LEXEME: %s\n", yytext);
			return T_IF;
			}
			
{T_LAMBDA}	{
			printf("TOKEN: LAMBDA    LEXEME: %s\n", yytext);
			return T_LAMBDA;
			}
			
{T_PRINT}		{
			printf("TOKEN: PRINT     LEXEME: %s\n", yytext);
			return T_PRINT;
			}
			
{T_INPUT}		{
			printf("TOKEN: INPUT     LEXEME: %s\n", yytext);
			return T_INPUT;
			}
{T_T}			{
			printf("TOKEN: T         LEXEME: %s\n", yytext);
			return T_T;
			}
			
{T_NIL}		{
			printf("TOKEN: NIL       LEXEME: %s\n", yytext);
			return T_NIL;
			}

{T_AND}		{
			printf("TOKEN: AND       LEXEME: %s\n", yytext);
			return T_AND;
			}
			
			
{T_OR}		{
			printf("TOKEN: OR        LEXEME: %s\n", yytext);
			return T_OR;
			}
			
{T_NOT}		{
			printf("TOKEN: NOT       LEXEME: %s\n", yytext);
			return T_NOT;
			}
{INTCONST}	     {
			printf("TOKEN: INTCONST  LEXEME: %s\n", yytext);
			return T_INTCONST;
			}
{STRCONST}	     {
			printf("TOKEN: STRCONST  LEXEME: %s\n", yytext);
			return T_STRCONST;
			}
{IDENT}		{
			printf("TOKEN: IDENT     LEXEME: %s\n", yytext);
			return T_IDENT;
			}
{NEWLINE}		{ numLines++; }

{WSPACE}		{ }

{COMMENT}		{ }
.			{
			printf("TOKEN: UNKNOWN   LEXEME: %s\n",
			       yytext);
			return T_UNKNOWN;
			}

%%