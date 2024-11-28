parallax: parallax.l parallax.y
	bison -d parallax.y  # Generate y.tab.h and y.tab.c
	flex parallax.l      # Use lex to generate lex.yy.c
	gcc -o parallax parallax.tab.c lex.yy.c -lfl  # Compile everything together
	bison -d -Wcounterexamples parallax.y

