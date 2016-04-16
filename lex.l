%{
#include<stdio.h>
%}
letter [a-zA-Z]
digit [0-9]
under [_]
%%
void |
int |
char |
include |
main |
printf |
if |
for |
break |
while {printf("\n %s is a keyword\n",yytext);}
"+" |
"-" |
"*" |
"/" {printf("\n %s is a binary operator",yytext);}
{digit}+ {printf("\n%s is an integer constant\n",yytext);}
{letter}({letter}|{digit}|{under})* {printf("\n %s is an identifier\n",yytext);}
\"[a-zA-Z0-9\(\)\%]*\" {printf("\n%s is a literal\n",yytext);}

%%
int main(int argc, char **argv)
{
FILE *fp;
fp=fopen(argv[1],"r");
yyin=fp;
yylex();
return 1;
}

yywrap()
{}


