/*	CS 3500 PLT Section 1A
 
	malloyl.y

 	Bison Specification file for malloyl.l

	Grammar:

	N_EXPR → N_CONST | T_IDENT |
			 T_LPAREN N_PARENTHESIZED_EXPR T_RPAREN
			 
	N_CONST → T_INTCONST | T_STRCONST | T_T | T_NIL

	N_PARENTHESIZED_EXPR → N_ARITHLOGIC_EXPR | N_IF_EXPR | 

					N_LET_EXPR | N_LAMBDA_EXPR |
					N_PRINT_EXPR | N_INPUT_EXPR |
					N_EXPR_LIST
					
	N_ARITHLOGIC_EXPR → N_UN_OP N_EXPR | N_BIN_OP N_EXPR N_EXPR

	N_IF_EXPR → T_IF N_EXPR N_EXPR N_EXPR

	N_LET_EXPR → T_LETSTAR T_LPAREN N_ID_EXPR_LIST T_RPAREN
				 N_EXPR
	 
	N_ID_EXPR_LIST → ε | N_ID_EXPR_LIST T_LPAREN T_IDENT N_EXPR
						T_RPAREN
	 
	N_LAMBDA_EXPR → T_LAMBDA T_LPAREN N_ID_LIST T_RPAREN
					N_EXPR
	 
	N_ID_LIST → ε | N_ID_LIST T_IDENT

	N_PRINT_EXPR → T_PRINT N_EXPR

	N_INPUT_EXPR → T_INPUT

	N_EXPR_LIST → N_EXPR N_EXPR_LIST | N_EXPR

	N_BIN_OP → N_ARITH_OP | N_LOG_OP | N_REL_OP

	N_ARITH_OP → T_MULT | T_SUB | T_DIV | T_ADD

	N_LOG_OP → T_AND | T_OR

	N_REL_OP → T_LT | T_GT | T_LE | T_GE | T_EQ | T_NE

	N_UN_OP → T_NOT

      To create the syntax analyzer:

        flex example.l
        bison example.y
        g++ example.tab.c -o parser
        parser < inputFileName
*/

%{
#include <stdio.h>
#include <stack>
#include <queue>
#include "SymbolTable.h"

/* Distinguish binary operator types*/
#define ARITH_OP 8
#define LOG_OP 9
#define REL_OP 10

/* Global variables */
int numLines = 1; 
int globalNumParams = 0; 
stack<SYMBOL_TABLE> scopeStack;
queue<int> numParams_lambda;

bool isLet = false;
bool isLambdaFn = false;

int yyerror(const char *s);
bool findEntryInAnyScope(const string theName);
void printTokenInfo(const char* tokenType, const char* lexeme);
void printRule(const char *, const char *);
void beginScope();
void endScope();
int getNumParams();

extern "C" 
{
    int yyparse(void);
    int yylex(void);
    int yywrap() { return 1; }
}

%}

%union{
		char* text;
		TYPE_INFO typeInfo;
	  };

/* Tokens */

%token T_IDENT T_INTCONST T_STRCONST 

%token T_UNKNOWN T_INPUT T_NIL

%token T_OR T_LT T_GT T_LE T_GE T_EQ

%token T_MULT T_SUB T_DIV T_ADD T_AND 
 
%token T_NE T_NOT T_LAMBDA T_LPAREN 

%token T_RPAREN T_LETSTAR T_IF T_T T_PRINT

// Associate identifier names with identifier tokens

%type <text> T_IDENT

%type <typeInfo> N_CONST N_EXPR N_PARENTHESIZED_EXPR N_IF_EXPR

%type <typeInfo> N_ARITHLOGIC_EXPR N_ID_EXPR_LIST N_LAMBDA_EXPR N_LET_EXPR

%type <typeInfo>  N_PRINT_EXPR N_EXPR_LIST N_INPUT_EXPR N_ID_LIST N_BIN_OP


/* Starting point */
%start		N_START

/* Translation rules */
%%
N_START		: 	N_EXPR
			{
				printRule("START", "EXPR");
				printf("\n---- Completed parsing ----\n\n");
				return 0;
			};
			
N_EXPR		: 	N_CONST
			{
				printRule("EXPR", "CONST");
				$$.type = $1.type;
				$$.numParams = $1.numParams;
				$$.returnType = NOT_APPLICABLE;
			}
                | T_IDENT
            {
				printRule("EXPR", "IDENT");
				
				bool search = findEntryInAnyScope(string($1));
				if(!search)
				{
					yyerror("Undefined identifier\n");
				}
				
				$$.type = scopeStack.top().getEntryTypeST($1);
				$$.numParams = scopeStack.top().getNumParamsST($1);
				$$.returnType = scopeStack.top().getReturnTypeST($1);
				
			}
                | T_LPAREN N_PARENTHESIZED_EXPR T_RPAREN
                
			{
				printRule("EXPR", "( PARENTHESIZED_EXPR )");
				$$.type = $2.type;
				$$.numParams = $2.numParams;
				$$.returnType = $2.returnType;
			};

N_CONST		: 	T_INTCONST
			{
				{
					printRule("CONST", "INTCONST");
					$$.type = INT;
					$$.numParams = 1;
					$$.returnType = NOT_APPLICABLE;
				}
			}
                | T_STRCONST
            {
				printRule("CONST", "STRCONST");
				$$.type = STR;
				$$.numParams = 1;
				$$.returnType = NOT_APPLICABLE;
			}
				| T_T
            {
				printRule("CONST", "t");
				$$.type = BOOL;
				$$.numParams = 1;
				$$.returnType = NOT_APPLICABLE;
			}
				| T_NIL 
			{
				printRule("CONST", "nil");
				$$.type = BOOL;
				$$.numParams = 1;
				$$.returnType = NOT_APPLICABLE;
			};
			
N_PARENTHESIZED_EXPR	: 	N_ARITHLOGIC_EXPR
						{
							printRule("PARENTHESIZED_EXPR", "ARITHLOGIC_EXPR");
							$$.type = $1.type;
							$$.numParams = $1.numParams;
							$$.returnType = $1.returnType;
						}
							| N_IF_EXPR
						{
							printRule("PARENTHESIZED_EXPR", "IF_EXPR");
							$$.type = $1.type;
							$$.numParams = $1.numParams;
							$$.returnType = $1.returnType;
						}
							| N_LET_EXPR
						{
							printRule("PARENTHESIZED_EXPR", "LET_EXPR");
							$$.type = $1.type;
							$$.numParams = $1.numParams;
							$$.returnType = $1.returnType;
						}
							| N_LAMBDA_EXPR 
						{
							printRule("PARENTHESIZED_EXPR", "LAMBDA_EXPR");
							$$.type = $1.type;
							$$.numParams = $1.numParams;
							$$.returnType = $1.returnType;
						}
							| N_PRINT_EXPR
						{
							printRule("PARENTHESIZED_EXPR", "PRINT_EXPR");
							$$.type = $1.type;
							$$.numParams = $1.numParams;
							$$.returnType = $1.returnType;
						}
							| N_INPUT_EXPR
						{
							printRule("PARENTHESIZED_EXPR", "INPUT_EXPR");
							$$.type = $1.type;
							$$.numParams = $1.numParams;
							$$.returnType = $1.returnType;
						}
							| N_EXPR_LIST
						{
							printRule("PARENTHESIZED_EXPR", "EXPR_LIST");
							
							if ( $1.numParams > numParams_lambda.front() && (isLambdaFn == true && !numParams_lambda.empty()))
							{
								//if($1.numParams > numParams_lambda.front())
									yyerror("Too many parameters in function call");
							}
							else if ( $1.numParams < numParams_lambda.front() && (isLambdaFn == true && !numParams_lambda.empty()))
							{
								//else if($1.numParams < numParams_lambda.front())
									yyerror("Too few parameters in function call");
							}
							
							//processed
							
							$$.type = $1.type;
							$$.numParams = $1.numParams;
							$$.returnType = $1.returnType;
							numParams_lambda.pop();
						};
						
N_ARITHLOGIC_EXPR 		: 	N_UN_OP N_EXPR
						{
							printRule("ARITHLOGIC_EXPR", "UN_OP EXPR");
							if ($2.type == FUNCTION)
							{
								yyerror("Arg 1 cannot be function");
							}

							$$.type = BOOL;
							$$.numParams = NOT_APPLICABLE;
							$$.returnType = NOT_APPLICABLE;
						}
							| N_BIN_OP N_EXPR N_EXPR
						{
							printRule("ARITHLOGIC_EXPR", "BIN_OP EXPR EXPR"); 
							
							if($1.type == ARITH_OP)
							{
								if($2.type & $3.type == INT)
								{
									$$.type = INT;
									$$.numParams = $2.numParams + $3.numParams;
									$$.returnType = INT;
								}
								
							    if($2.type != INT)
									yyerror("Arg 1 must be integer");
								
								if($3.type != INT)
									yyerror("Arg 2 must be integer");
							}
							
							else if($1.type == LOG_OP)
							{
								if($2.type == FUNCTION)
									yyerror("Arg 1 cannot be function");
								else if ($3.type == FUNCTION)
									yyerror("Arg 2 cannot be function");
								else
								{
									$$.type = BOOL;
									$$.numParams = $2.numParams + $3.numParams;
									$$.returnType = BOOL;
								}
								
							}
							
							else if ($1.type == REL_OP)
							{
								
								if(($2.type == FUNCTION) || ($2.type != INT && $2.type != STR))
								{
									yyerror("Arg 1 must be integer or string");
								}
								
								if(($3.type == FUNCTION) || ($3.type != INT && $3.type != STR))
								{
									yyerror("Arg 2 must be integer or string");
								}
								
								else
								{
									$$.type = BOOL;
									$$.numParams = $2.numParams + $3.numParams;
									$$.returnType = BOOL;
								}
							}
							
							else
							{
								yyerror("Something went wrong....");
							}
							
						};
						
N_IF_EXPR   : 	T_IF N_EXPR N_EXPR N_EXPR
			{
				printRule("IF_EXPR", "if EXPR EXPR EXPR"); 

				// No argument can be function
				if($2.type == FUNCTION)
				{
					yyerror("Arg 1 cannot be function");
				}

				else if($3.type == FUNCTION)
				{
					yyerror("Arg 2 cannot be function");
				}

				else if($4.type == FUNCTION)
				{
					yyerror("Arg 3 cannot be function");
				}
				else if(($3.type | $4.type) == INT) 
				{
					$$.type = INT;
					$$.numParams = $2.numParams + $3.numParams + $4.numParams;
					$$.returnType = INT;
				}

				else if(($3.type | $4.type) == STR) 
				{
					$$.type = STR;
					$$.numParams = $2.numParams + $3.numParams + $4.numParams;
					$$.returnType = STR;
				}	

				else if(($3.type | $4.type) == BOOL) 
				{
					$$.type = BOOL;
					$$.numParams = $2.numParams + $3.numParams + $4.numParams;
					$$.returnType = BOOL;
				}

				else if(($3.type | $4.type) == INT_OR_STR) 
				{
					$$.type = INT_OR_STR;
					$$.numParams = $2.numParams + $3.numParams + $4.numParams;
					$$.returnType = INT_OR_STR;
				}

				else if(($3.type | $4.type) == INT_OR_BOOL) 
				{
					$$.type = INT_OR_BOOL;
					$$.numParams = $2.numParams + $3.numParams + $4.numParams;
					$$.returnType = INT_OR_BOOL;
				}

				else if(($3.type | $4.type) == STR_OR_BOOL) 
				{
					$$.type = STR_OR_BOOL;
					$$.numParams = $2.numParams + $3.numParams + $4.numParams;
					$$.returnType = STR_OR_BOOL;
				}

				else if(($3.type | $4.type) == INT_OR_STR_OR_BOOL) 
				{
					$$.type = INT_OR_STR_OR_BOOL;
					$$.numParams = $2.numParams + $3.numParams + $4.numParams;
					$$.returnType = INT_OR_STR_OR_BOOL;
				}

			};
			
N_LET_EXPR  : 	T_LETSTAR T_LPAREN N_ID_EXPR_LIST T_RPAREN N_EXPR
			{
				printRule("LET_EXPR", "let* ( ID_EXPR_LIST ) EXPR"); 
				endScope();
				
				isLet = true;
				isLambdaFn = false;
				
				if($5.type == FUNCTION)
				{
					yyerror("Arg 2 cannot be function");
				}

				else
				{
					// N_EXPR type determines N_LET_EXPR
					$$.type = $5.type;
					$$.numParams = globalNumParams;
					$$.returnType = $5.returnType;
				}
			};
			
N_ID_EXPR_LIST    : 	//EPSILON
				  {
						printRule("ID_EXPR_LIST", "epsilon");
						$$.type = UNDEFINED;
						$$.numParams = 0;
						$$.returnType = UNDEFINED;
				  }
						| N_ID_EXPR_LIST T_LPAREN T_IDENT N_EXPR T_RPAREN
				  {
				  
				  
						printRule("ID_EXPR_LIST", "ID_EXPR_LIST ( IDENT EXPR )");
						printf("___Adding %s to symbol table\n", $3);
						
						// N_EXPR type determines T_IDENT type 
						// SYMBOL_TABLE_ENTRY(const string theName, const int theType, const int numParams, const int returnType)
						if(!scopeStack.top().addEntry(SYMBOL_TABLE_ENTRY(string($3), $4.type, $4.numParams, $4.returnType)))
						{
							yyerror("Multiply defined identifier\n");
						}

						
						//check if Let* expr
						if (isLet == true)
							$$.type = $4.type;
						else
							$$.returnType = $4.returnType;
							
						$$.numParams = scopeStack.top().getNumParamsST(string($3));
						$$.returnType = $4.returnType;
				  };
				  
N_LAMBDA_EXPR     : 	T_LAMBDA T_LPAREN N_ID_LIST T_RPAREN N_EXPR
				  {
						printRule("LAMBDA_EXPR", "lambda ( ID_LIST ) EXPR");
						
						isLambdaFn = true;
						globalNumParams = getNumParams();

						endScope();

						// N_EXPR cannot be a function
						if($5.type == FUNCTION)
						{
							yyerror("Arg 2 cannot be function");
						}
						
						if(globalNumParams > $3.numParams)
							yyerror("Too many parameters in function call");
						if(globalNumParams < $3.numParams)
							yyerror("Too few parameters in function call");

						$$.type = FUNCTION;
						$$.numParams = globalNumParams;
						numParams_lambda.push($3.numParams);
						$$.returnType = $5.type;

				  };
				  
N_ID_LIST         :		//EPSILON
				  {
						printRule("ID_LIST", "epsilon");
						
						$$.type = UNDEFINED;
						$$.numParams = 0;
						$$.returnType = UNDEFINED;
				  }
						| N_ID_LIST T_IDENT
				  {
						printRule("ID_LIST", "ID_LIST IDENT");
						
						printf("___Adding %s to symbol table\n", $2);

						// SYMBOL_TABLE_ENTRY(const string theName, const int theType, const int numParams, const int returnType)
						if(!scopeStack.top().addEntry(SYMBOL_TABLE_ENTRY(string($2), INT, UNDEFINED, UNDEFINED)))
						{
							yyerror("Multiply defined identifier\n");
						}

						$$.type = INT;
						$$.numParams += 1;
						$$.returnType = INT;
						
				  };	
				  
N_PRINT_EXPR      :		T_PRINT N_EXPR 
				  {
						printRule("PRINT_EXPR", "print EXPR");

						if ($2.type == FUNCTION)
						{
							yyerror("Arg 1 cannot be function");
						}

						$$.type = $2.type;
						$$.numParams = 0;
						$$.returnType = $2.returnType;
				  };
						
N_INPUT_EXPR      :   	T_INPUT
				  {
						printRule("INPUT_EXPR", "input");
						$$.type = INT;
						$$.numParams = 0;
						$$.returnType = INT;

				  };
				  
N_EXPR_LIST       : 	N_EXPR N_EXPR_LIST 
				  {
						printRule("EXPR_LIST", "EXPR EXPR_LIST");
						//$1 expected
						//$2 actual 
						
						// First check that N_EXPR is a function name or defn
						if($1.type == FUNCTION)
						{	

						// Assign resulting type of the N_EXPR_LIST 
							$$.type = $1.returnType;
						}
						else
						{
							$$.type = $1.type;
							$$.numParams = $2.numParams + 1;
							$$.returnType = $1.returnType;
							globalNumParams = $$.numParams;
						}

						
				  }
						| N_EXPR 
				  {
						printRule("EXPR_LIST", "EXPR");

						if($1.type == FUNCTION)
						{
							$$.type = $1.returnType;
						}
						else
						{
							$$.type = $1.type;
							$$.numParams = 0;
							$$.returnType = $1.returnType;
						}
				  };
				  
N_BIN_OP        : 	N_ARITH_OP 
				{

					printRule("BIN_OP", "ARITH_OP");
					$$.type = ARITH_OP;
				}
					| N_LOG_OP
				{
					
					printRule("BIN_OP", "LOG_OP");
					$$.type = LOG_OP;
				}
					| N_REL_OP
				{
					
					printRule("BIN_OP", "REL_OP");
					$$.type = REL_OP;
				};
				
N_ARITH_OP      : 	T_MULT 
				{
					printRule("ARITH_OP", "*");
				}
					| T_SUB 
				{
					printRule("ARITH_OP", "-");
				}
					| T_DIV
				{
					printRule("ARITH_OP", "/");
				}
					| T_ADD
				{
					printRule("ARITH_OP", "+");
				}; 
				  
N_LOG_OP        : T_AND				  
				{
					printRule("LOG_OP", "and");
				}
					| T_OR
				{
					printRule("LOG_OP", "or");
				};

N_REL_OP        : 	T_LT 
				{
					printRule("REL_OP", "<");
				}
					| T_GT
				{
					printRule("REL_OP", ">");
				}
					| T_LE
				{
					printRule("REL_OP", "<=");
				}
					| T_GE  
				{
					printRule("REL_OP", ">=");
				}
					| T_EQ
				{
					printRule("REL_OP", "=");
				}
					| T_NE 
				{
					printRule("REL_OP", "/=");
				};
				
N_UN_OP			:	T_NOT
				{
					printRule("UN_OP", "not");
				};
				
				  		
%%

#include "lex.yy.c"
extern FILE *yyin;

void beginScope()
{
	scopeStack.push(SYMBOL_TABLE());
	printf("\n___Entering new scope...\n\n");
}

void endScope()
{
	scopeStack.pop();
	printf("\n___Exiting scope...\n\n");
}

int getNumParams()
{
	int size = scopeStack.top().getHashTable().size();
	return size;
}


bool findEntryInAnyScope(const string theName) 
{
	if (scopeStack.empty( )) 
		return(false);
		
	bool found = scopeStack.top( ).findEntry(theName);
	
	if (found)
		return(true);
		
	else 
		{ 
		// check in "next higher" scope
			SYMBOL_TABLE symbolTable = scopeStack.top( );
			scopeStack.pop( );
			found = findEntryInAnyScope(theName);
			scopeStack.push(symbolTable); 
			// restore the stack
			return(found);
		}
}


void printTokenInfo(const char* tokenType, const char* lexeme) 
{
  printf("TOKEN: %s   LEXEME: %s\n", tokenType, lexeme);
}

void printRule(const char *lhs, const char *rhs) 
{
  printf("%s -> %s\n", lhs, rhs);
  return;
}

int yyerror(const char *s) 
{
  printf("Line %d: %s\n", numLines, s);
  
  exit(1);
  
  //return(1);
}

int main() 
{
  do 
  {
	yyparse();
  } while (!feof(yyin));

 
  return(0);
}
