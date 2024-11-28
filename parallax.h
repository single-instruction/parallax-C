/* tinyC.h */
#ifndef PRALLAX_H
#define PRALLAX_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern const char* token_name(int current_token);
extern char* yytext;
extern int yylex(void);
extern FILE* yyin;

#endif 