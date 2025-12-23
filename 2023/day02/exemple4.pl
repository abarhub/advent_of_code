/*
https://www.metalevel.at/prolog/dcg

:- set_prolog_flag(double_quotes, chars).
*/


parser([]) --> [].

/*
parser(Tree) --> pgame(Tree).
*/
parser(Tree) --> ptest1(Tree).

parser(Tree) --> pgame2(Tree).

pgame([ "game", int(N) ]) --> [ 'g','a','m','e','('] , num(N), [ ')' ] .

ptest1( ['test'] )  --> [ 't','e','s','t' ] .

ptest1( ['test2'] )  --> [ 'T','e','s','t','5' ] .

ptest1( ['test3', int(N)] )  --> [ 'T','E','s','t' ], num(N) .

ptest1( ['test4'] )  --> [ 'T','E','S','t' ], ['5'] .

ptest1( ['test5', int(N)] )  --> [ 'T','e','S','t' ], num(N) .

ptest1( ['test6'], N )  --> [ 't','E','s','t' ], num2(N) .

ptest1( ['test7'], int(N) )  --> [ 'T','o','s','t' ], { N is 5 }  .


num(N) --> [N], { number(N) }.

num3(N) --> ['0'], { N is 0 }.
num3(N) --> ['1'], { N is 1 }.
num3(N) --> ['2'], { N is 2 }.
num3(N) --> ['3'], { N is 3 }.
num3(N) --> ['4'], { N is 4 }.
num3(N) --> ['5'], { N is 5 }.
num3(N) --> ['6'], { N is 6 }.
num3(N) --> ['7'], { N is 7 }.
num3(N) --> ['8'], { N is 8 }.
num3(N) --> ['9'], { N is 9 }.


num2(N) --> num3(N1), num2(N2), { N is N1*10+N2 }.
num2(N) --> num3(N).


expr(Z) --> num3(Z).
expr(Z) --> num3(X), [+], expr(Y), {Z is X+Y}.
expr(Z) --> num3(X), [-], expr(Y), {Z is X-Y}.
num3(D) --> [D], {number(D)}.

pgame2(game2(N,Bleu, Vert, Rouge)) --> [ 'g','a','m','e','('] , num2(N),[','], liste1(Bleu, Vert, Rouge), [ ')' ] .

liste1(Bleu, Vert, Rouge) --> 
			"[", liste2(Bleu1, Vert1, Rouge1), ";", liste1(Bleu2, Vert2, Rouge2),  "]" , { Bleu is Bleu1 + Bleu2, Vert is Vert1 + Vert2 , Rouge is Rouge1 + Rouge2 } .
liste1(Bleu, Vert, Rouge) --> "[", liste2(Bleu, Vert, Rouge),  "]".
liste1(Bleu, Vert, Rouge) --> "[", "]", { Bleu is 0, Vert is 0 , Rouge is 0 }.

liste2(Bleu, Vert, Rouge) --> "[", cubeliste(Bleu1, Vert1, Rouge1), ",", liste2(Bleu2, Vert2, Rouge2),  "]" , { Bleu is Bleu1 + Bleu2, Vert is Vert1 + Vert2 , Rouge is Rouge1 + Rouge2 } .
liste2(Bleu, Vert, Rouge) --> "[", cubeliste(Bleu, Vert, Rouge), "]"  .
liste2(Bleu, Vert, Rouge) --> "[",   "]" , { Bleu is 0, Vert is 0 , Rouge is 0 }.


cube1(Bleu, Vert, Rouge) --> "cube", "(", num2(N), ",blue", ")" , {Bleu is N , Vert is 0, Rouge is 0 , write('cube_bleu')} . 
cube1(Bleu, Vert, Rouge) --> "cube", "(", num2(N), ",red", ")" , {Rouge is N , Bleu is 0, Vert is 0 , write('cube_rouge')} . 
cube1(Bleu, Vert, Rouge) --> "cube", "(", num2(N), ",green", ")" , {Vert is N , Bleu is 0, Rouge is 0 , write('cube_vert')} .

cubeliste(Bleu, Vert, Rouge) --> cube1(Bleu, Vert, Rouge) .
cubeliste(Bleu, Vert, Rouge) --> cube1(Bleu1, Vert1, Rouge1), ",", cubeliste(Bleu2, Vert2, Rouge2) , { Bleu is Bleu1 + Bleu2, Vert is Vert1 + Vert2 , Rouge is Rouge1 + Rouge2 }.


/*
game(Bleu, Vert, Rouge) --> "game", "(", liste1(Bleu, Vert, Rouge), ")".

liste1(Bleu, Vert, Rouge) --> "[", "]".
liste1(Bleu, Vert, Rouge) --> "[", liste2(Bleu, Vert, Rouge),  "]".

liste2(Bleu, Vert, Rouge) --> "[",   "]" .
liste2(Bleu, Vert, Rouge) --> "[", cubeliste(Bleu, Vert, Rouge),   "]" .

cubeliste(Bleu, Vert, Rouge) --> cube1(Bleu, Vert, Rouge), "," cubeliste(Bleu, Vert, Rouge) .
cubeliste(Bleu, Vert, Rouge) --> cube1(Bleu, Vert, Rouge) .

cube1, [Bleu, Vert, Rouge] --> "cube", "(", N, "blue", ")" , {Bleu is Bleu + N } . 
cube1, [Bleu, Vert, Rouge] --> "cube", "(", N, "red", ")" , {Rouge is Rouge + N } . 
cube1, [Bleu, Vert, Rouge] --> "cube", "(", N, "green", ")" , {Vert is Vert + N } . 


phrase(parser(T), "tEst4").

phrase(parser(T), "TEst5").

phrase(V, [11, +, 2, -, 7],[]).

expr(V, [11, +, 2, -, 7],[]).

phrase(expr(V), [11, +, 2, -, 7]).

phrase(expr(V), "1+2-7").

phrase(pgame2(T), "game(5)").


phrase(pgame2(T), "game(5,[[cube(5,red)]])").


phrase(pgame2(T), "game(5,[[cube(5,red),cube(4,blue),cube(5,green)]])").

phrase(pgame2(T), "game(5,[[cube(5,red),cube(4,blue),cube(15,green)]])").

*/

/*


phrase(parser(T), "game(1)").

phrase(game, "game(1)").


phrase(game(Bleu, Vert, Rouge), "game(1,[[cube(3,blue),cube(4,red)],[cube(1,red),cube(2,green),cube(6,blue)],[cube(2,green)]])").

phrase(parser(T), "test").
phrase(parser(T), "Test5").

phrase(parser(T), "TEst5").


*/