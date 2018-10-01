all: flex bison program
	
flex: trendleys.l
	flex trendleys.l
	
bison:
	bison trendleys.y
	
program:
	g++ trendleys.tab.c -o parser
	
