%{
#include "parallax.h"
#include "parallax.tab.h"

const char* token_name(int current_token) {
    static char buffer[100];
    
    switch (current_token) {
        case IDENTIFIER:
            snprintf(buffer, sizeof(buffer), "IDENTIFIER: %s", yytext);
            break;
        case NUMBER:
            snprintf(buffer, sizeof(buffer), "NUMBER: %s", yytext);
            break;
        case STRING:
            snprintf(buffer, sizeof(buffer), "STRING: %s", yytext);
            break;
        case TYPE:
            snprintf(buffer, sizeof(buffer), "TYPE: %s", yytext);
            break;
        case KEYWORD:
            snprintf(buffer, sizeof(buffer), "KEYWORD: %s", yytext);
            break;
        case BOOL:
            snprintf(buffer, sizeof(buffer), "BOOL: %s", yytext);
            break;
        case PLUS:
            snprintf(buffer, sizeof(buffer), "PLUS: +");
            break;
        case MINUS:
            snprintf(buffer, sizeof(buffer), "MINUS: -");
            break;
        case MULT:
            snprintf(buffer, sizeof(buffer), "MULT: *");
            break;
        case DIV:
            snprintf(buffer, sizeof(buffer), "DIV: /");
            break;
        case MOD:
            snprintf(buffer, sizeof(buffer), "MOD: %%");
            break;
        case AND_OP:
            snprintf(buffer, sizeof(buffer), "AND_OP: &&");
            break;
        case OR_OP:
            snprintf(buffer, sizeof(buffer), "OR_OP: ||");
            break;
        case EQ_OP:
            snprintf(buffer, sizeof(buffer), "EQ_OP: ==");
            break;
        case NE_OP:
            snprintf(buffer, sizeof(buffer), "NE_OP: !=");
            break;
        case LT_OP:
            snprintf(buffer, sizeof(buffer), "LT_OP: <");
            break;
        case GT_OP:
            snprintf(buffer, sizeof(buffer), "GT_OP: >");
            break;
        case LE_OP:
            snprintf(buffer, sizeof(buffer), "LE_OP: <=");
            break;
        case GE_OP:
            snprintf(buffer, sizeof(buffer), "GE_OP: >=");
            break;
        case ASSIGN:
            snprintf(buffer, sizeof(buffer), "ASSIGN: =");
            break;
        case ADD_ASSIGN:
            snprintf(buffer, sizeof(buffer), "ADD_ASSIGN: +=");
            break;
        case SUB_ASSIGN:
            snprintf(buffer, sizeof(buffer), "SUB_ASSIGN: -=");
            break;
        case MUL_ASSIGN:
            snprintf(buffer, sizeof(buffer), "MULT_ASSIGN: *=");
            break;
        case DIV_ASSIGN:
            snprintf(buffer, sizeof(buffer), "DIV_ASSIGN: /=");
            break;
        case SEMICOLON:
            snprintf(buffer, sizeof(buffer), "SEMICOLON: ;");
            break;
        case COMMA:
            snprintf(buffer, sizeof(buffer), "COMMA: ,");
            break;
        case LBRACE:
            snprintf(buffer, sizeof(buffer), "LBRACE: {");
            break;
        case RBRACE:
            snprintf(buffer, sizeof(buffer), "RBRACE: }");
            break;
        case LPAREN:
            snprintf(buffer, sizeof(buffer), "LPAREN: (");
            break;
        case RPAREN:
            snprintf(buffer, sizeof(buffer), "RPAREN: )");
            break;
        default:
            snprintf(buffer, sizeof(buffer), "Unknown token: %d", current_token);
    }
    return buffer;
}

%}

%%

"void"      { return TYPE; }
"u8"        { return TYPE; }
"u16"       { return TYPE; }
"u32"       { return TYPE; }
"u64"       { return TYPE; }
"i8"        { return TYPE; }
"i16"       { return TYPE; }
"i32"       { return TYPE; }
"i64"       { return TYPE; }
"string"    { return TYPE; }

"fn"        { return KEYWORD; }
"return"    { return KEYWORD; }
"if"        { return KEYWORD; }
"else"      { return KEYWORD; }
"while"     { return KEYWORD; }
"for"       { return KEYWORD; }
"break"     { return KEYWORD; }
"continue"  { return KEYWORD; }
"true"      { return BOOL; }
"false"     { return BOOL; }

"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MULT; }
"/"         { return DIV; }
"%"         { return MOD; }

"&&"        { return AND_OP; }
"||"        { return OR_OP; }
"!"         { return NOT_OP; }

"=="        { return EQ_OP; }
"!="        { return NE_OP; }
"<="        { return LE_OP; }
">="        { return GE_OP; }
"<"         { return LT_OP; }
">"         { return GT_OP; }

"="         { return ASSIGN; }
"+="        { return ADD_ASSIGN; }
"-="        { return SUB_ASSIGN; }
"*="        { return MUL_ASSIGN; }
"/="        { return DIV_ASSIGN; }
"%="        { return MOD_ASSIGN; }

";"         { return SEMICOLON; }
","         { return COMMA; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
"("         { return LPAREN; }
")"         { return RPAREN; }

[0-9]+      { yylval.num = atoi(yytext); return NUMBER; }
\"([^\\"]|\\.)*\"  { yylval.str = strdup(yytext); return STRING; }

[a-zA-Z_][a-zA-Z0-9_]* { return IDENTIFIER; }

[ \t\r\n]+  { /* Ignore whitespace and newlines */ }

.           { printf("Unrecognized character: %s\n", yytext); }

%%

int yywrap() { return 1; }
