%{

#include "parallax.h"


void yyerror(const char *s);
void print_parser_action(const char* rule);
int parsing_debug = 1;  // Enable parsing debug output
#define YYDEBUG 1
int yydebug;
%}

%debug

// Union to hold different value types
%union {
    int ival;           // Integer value
    char* sval;         // String value (for identifiers, etc.)
    double dval;        // Double value for potential floating-point support
    struct {            // Structure to hold both type and value
        char* type;     // Type of the identifier or expression
        char* value;    // Value of the identifier or expression
    } expr;
    int num;
    char* str;
}

// Token definitions with explicit type associations
%token <sval> IDENTIFIER TYPE KEYWORD
%token <ival> NUMBER
%token <sval> BOOL
%token LBRACE RBRACE LPAREN RPAREN COMMA SEMICOLON 
%token PLUS MINUS MULT DIV MOD
%token AND_OP OR_OP EQ_OP NE_OP GT_OP LT_OP GE_OP LE_OP
%token ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN
%token ASSIGN NOT_OP MOD_ASSIGN
%token STRING

// Define non-terminal types
%type <expr> program
%type <expr> function_definition
%type <expr> parameter_list
%type <expr> parameter
%type <expr> function_body
%type <expr> statement_list
%type <expr> statement
%type <expr> expression
%type <expr> arithmetic_expression
%type <expr> return_statement
%type <expr> factor
%type <expr> term

// Precedence and associativity
%left OR_OP
%left AND_OP
%left EQ_OP NE_OP
%left LT_OP GT_OP LE_OP GE_OP
%left PLUS MINUS
%left MULT DIV MOD
%right NOT_OP

%start program

%%

program:
    statement_list {
        if(parsing_debug) print_parser_action("program -> statement_list");
    }
    ;

statement_list:
    statement {
        if(parsing_debug) print_parser_action("statement_list -> statement");
    }
    | statement_list statement {
        if(parsing_debug) print_parser_action("statement_list -> statement_list statement");
    }
    ;

statement:
    function_definition {
        if(parsing_debug) print_parser_action("statement -> function_definition");
    }
    | return_statement SEMICOLON {
        if(parsing_debug) print_parser_action("statement -> return_statement SEMICOLON");
    }
    | expression SEMICOLON {
        if(parsing_debug) print_parser_action("statement -> expression SEMICOLON");
    }
    ;

function_definition:
    TYPE IDENTIFIER LPAREN parameter_list RPAREN LBRACE function_body RBRACE {
        if(parsing_debug) print_parser_action("function_definition -> TYPE IDENTIFIER LPAREN parameter_list RPAREN LBRACE function_body RBRACE");
    }
    ;

parameter_list:
    /* empty */ {
        if(parsing_debug) print_parser_action("parameter_list -> (empty)");
    }
    | parameter {
        if(parsing_debug) print_parser_action("parameter_list -> parameter");
    }
    | parameter_list COMMA parameter {
        if(parsing_debug) print_parser_action("parameter_list -> parameter_list COMMA parameter");
    }
    ;

parameter:
    TYPE IDENTIFIER {
        if(parsing_debug) print_parser_action("parameter -> TYPE IDENTIFIER");
    }
    ;

function_body:
    /* empty */ {
        if(parsing_debug) print_parser_action("function_body -> (empty)");
    }
    | statement_list {
        if(parsing_debug) print_parser_action("function_body -> statement_list");
    }
    ;

return_statement:
    KEYWORD expression {
        if(parsing_debug) print_parser_action("return_statement -> KEYWORD expression");
    }
    ;

expression:
    arithmetic_expression {
        if(parsing_debug) print_parser_action("expression -> arithmetic_expression");
    }
    | IDENTIFIER {
        if(parsing_debug) print_parser_action("expression -> IDENTIFIER");
    }
    | NUMBER {
        if(parsing_debug) print_parser_action("expression -> NUMBER");
    }
    ;

arithmetic_expression:
    term {
        if(parsing_debug) print_parser_action("arithmetic_expression -> term");
    }
    | arithmetic_expression PLUS term {
        if(parsing_debug) print_parser_action("arithmetic_expression -> arithmetic_expression PLUS term");
    }
    | arithmetic_expression MINUS term {
        if(parsing_debug) print_parser_action("arithmetic_expression -> arithmetic_expression MINUS term");
    }
    ;

term:
    factor {
        if(parsing_debug) print_parser_action("term -> factor");
    }
    | term MULT factor {
        if(parsing_debug) print_parser_action("term -> term MULT factor");
    }
    | term DIV factor {
        if(parsing_debug) print_parser_action("term -> term DIV factor");
    }
    ;

factor:
    NUMBER {
        if(parsing_debug) print_parser_action("factor -> NUMBER");
    }
    | IDENTIFIER {
        if(parsing_debug) print_parser_action("factor -> IDENTIFIER");
    }
    | LPAREN expression RPAREN {
        if(parsing_debug) print_parser_action("factor -> LPAREN expression RPAREN");
    }
    ;

%%

// Helper function to print parser actions with proper memory management
void print_parser_action(const char* rule) {
    static int depth = 0;
    for(int i = 0; i < depth; i++) printf("  ");
    printf("PARSE: %s\n", rule);
    depth++;
}

// Main function for parsing
int main(int argc, char **argv) {
    // Initialize yydebug
    yydebug = 1;

    // Open the input file
    yyin = stdin;

    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Could not open %s\n", argv[1]);
            return 1;
        }
    }

    printf("\n=== Starting Lexical Analysis ===\n\n");

    // First pass: Show tokens
    int token;
    while ((token = yylex()) != 0) {
        const char* token_str = token_name(token);
        printf("TOKEN: %s\n", token_str);
    }

    // Reset file for parsing
    rewind(yyin);

    printf("\n=== Starting Parsing ===\n\n");

    // Do the parsing
    yyparse();

    if (yyin != stdin) {
        fclose(yyin);
    }

    return 0;
}

// Error handling function
void yyerror(const char *s) {
   fprintf(stderr, "Parse Error: %s\n", s);
}