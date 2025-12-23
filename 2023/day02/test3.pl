/*
game(1,[[cube(3,blue),cube(4,red)],[cube(1,red),cube(2,green),cube(6,blue)],[cube(2,green)]]).
game(2,[[cube(1,blue),cube(2,green)],[cube(3,green),cube(4,blue),cube(1,red)],[cube(1,green),cube(1,blue)]]).
game(3,[[cube(8,green),cube(6,blue),cube(20,red)],[cube(5,blue),cube(4,red),cube(13,green)],[cube(5,green),cube(1,red)]]).
game(4,[[cube(1,green),cube(3,red),cube(6,blue)],[cube(3,green),cube(6,red)],[cube(3,green),cube(15,blue),cube(14,red)]]).
game(5,[[cube(6,red),cube(1,blue),cube(3,green)],[cube(2,blue),cube(1,red),cube(2,green)]]).


test1(game(A,L),B,R,G) :- 
	parcourt(A,L,B,R,G), 
	write('Le jeux '), write(A), write(' a : '),
	write(B), write(' bleu, '),
	write(R), write(' rouge, '),
	write(G), write(' vert'), nl.

parcourt(_,[],0,0,0) :- !.

parcourt(A,[H|T],B,R,G) :- 
	parcourt2(A,H,B,R,G),
	parcourt(A,T,B,R,G).


parcourt2(_,[],0,0,0) :-  !.

parcourt2(A,[cube(X,blue)|T],B,R,G) :- 
	B is B + X,
	parcourt(A,T,B,R,G).

parcourt2(A,[cube(X,red)|T],B,R,G) :- 
	R is R + X,
	parcourt(A,T,B,R,G).

parcourt2(A,[cube(X,green)|T],B,R,G) :- 
	G is G + X,
	parcourt(A,T,B,R,G).


test2(A,B,R,G) :- 
	test1(game(A,_),B,R,G).

*/

/*
:- set_prolog_flag(double_quotes, chars).
*/
:- use_module(library(pio)).
:- use_module(library(dcg/basics)).


lines([])           --> call(eos), !.
lines([Line|Lines]) --> line(Line), lines(Lines).


eos([], []).


line([])     --> ( "\n" ; call(eos) ), !.
line([L|Ls]) --> [L], line(Ls) .


affiche([]) :- nl .
affiche([H|T]) :- write(H), affiche(T).

my_read_file(File,List):-
    open(File, read, Stream),
    read_line(Stream, List),
    close(Stream).


/*
match([H|T]) -->  "game" , "(" , listeCube , ")" .
		
listeCube() --> "[" listeCube2 "]".

listeCube2() --> "[" listeCube3 "]".

listeCube3() -->   .
listeCube3() -->  cube "," listeCube3 .

cube() -->  cube .

*/


stream_lines0(File,Lines) :-
	open(File, read, Input),
	stream_lines(Input,Lines),
	close(Input).
	

stream_lines(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "\n", Lines).




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

/*
expr(Z) --> num3(Z).
expr(Z) --> num3(X), [+], expr(Y), {Z is X+Y}.
expr(Z) --> num3(X), [-], expr(Y), {Z is X-Y}.
num3(D) --> [D], {number(D)}.
*/

pgame2(game2(N,Bleu, Vert, Rouge)) --> [ 'g','a','m','e','('] , num2(N),[','], liste1(Bleu, Vert, Rouge), [ ')' ] .

liste01(Bleu, Vert, Rouge) --> 
			liste2(Bleu1, Vert1, Rouge1), ";", liste01(Bleu2, Vert2, Rouge2),  { Bleu is Bleu1 + Bleu2, Vert is Vert1 + Vert2 , Rouge is Rouge1 + Rouge2 } .


liste1(Bleu, Vert, Rouge) --> "[", liste01(Bleu, Vert, Rouge),  "]".
liste1(Bleu, Vert, Rouge) --> "[", "]", { Bleu is 0, Vert is 0 , Rouge is 0 }.

liste02(Bleu, Vert, Rouge) --> cubeliste(Bleu1, Vert1, Rouge1), ",", liste02(Bleu2, Vert2, Rouge2),  { Bleu is Bleu1 + Bleu2, Vert is Vert1 + Vert2 , Rouge is Rouge1 + Rouge2 } .
liste02(Bleu, Vert, Rouge) --> cubeliste(Bleu, Vert, Rouge)  .

liste2(Bleu, Vert, Rouge) --> "[", liste02(Bleu, Vert, Rouge), "]"  .
liste2(Bleu, Vert, Rouge) --> "[",   "]" , { Bleu is 0, Vert is 0 , Rouge is 0 }.


cube1(Bleu, Vert, Rouge) --> "cube", "(", num2(N), ",blue", ")" , {Bleu is N , Vert is 0, Rouge is 0 , write('cube_bleu')} . 
cube1(Bleu, Vert, Rouge) --> "cube", "(", num2(N), ",red", ")" , {Rouge is N , Bleu is 0, Vert is 0 , write('cube_rouge')} . 
cube1(Bleu, Vert, Rouge) --> "cube", "(", num2(N), ",green", ")" , {Vert is N , Bleu is 0, Rouge is 0 , write('cube_vert')} .

cubeliste(Bleu, Vert, Rouge) --> cube1(Bleu, Vert, Rouge) .
cubeliste(Bleu, Vert, Rouge) --> cube1(Bleu1, Vert1, Rouge1), ",", cubeliste(Bleu2, Vert2, Rouge2) , { Bleu is Bleu1 + Bleu2, Vert is Vert1 + Vert2 , Rouge is Rouge1 + Rouge2 }.


analyse2([]) :- write('fin'), nl.
analyse2([H|T]) :- write('debut'),write(H),write('debut2'),phrase(pgame2(S), H), 
		write('Le jeux '), /*write(N), write(' a : '),
		write(B), write(' bleu, '),
		write(R), write(' rouge, '),
		write(V), write(' vert'),*/ nl,
		analyse2(T).
		

analyse3([H|T]) :- write('debut'),write(H),
		string_to_list(H,H2),
		phrase(pgame2(S), H2), 
		write('Le jeux '), /*write(N), write(' a : '),
		write(B), write(' bleu, '),
		write(R), write(' rouge, '),
		write(V), write(' vert'),*/ nl.


analyseFichier(Ls) :-
	phrase_from_file(lines(Ls), 'test1.txt'),
	write('liste:'),write(Ls),
	analyse3(Ls)
	.


analyseFichier2(Ls,File) :-
	stream_lines0(File,Ls),
	write('liste:'),write(Ls),
	analyse3(Ls)
	.

liste05 --> elt05, ",", liste05 .
liste05 --> elt05 .

elt05 --> "a".

liste005 --> "[", liste05, "]" .
liste005 --> "[",  "]" .

/*

phrase(pgame2(S), "game(1,[[cube(3,blue),cube(4,red)],[cube(1,red),cube(2,green),cube(6,blue)],[cube(2,green)]])").
phrase(pgame2(S), [103,97,109,101,40,49,44,91,91,99,117,98,101,40,51,44,98,108,117,101,41,44,99,117,98,101,40,52,44,114,101,100,41,93,44,91,99,117,98,101,40,49,44,114,101,100,41,44,99,117,98,101,40,50,44,103,114,101,101,110,41,44,99,117,98,101,40,54,44,98,108,117,101,41,93,44,91,99,117,98,101,40,50,44,103,114,101,101,110,41,93,93,41]).

phrase(liste05, "a,a,a,a").
phrase(liste05, "a").

phrase(liste005, "[a]").

*/


/*
?- phrase_from_file(lines(Ls), 'test1.txt'), affiche(Ls).
phrase_from_file(lines(Ls), 'test1.txt').
*/

/*
:- use_module(library(dcg/basics)).

file_contains(File, Pattern) :-
        phrase_from_file(match(Pattern), File).

match(Pattern) -->
        string(_),
        string(Pattern),
        remainder(_).

match_count(File, Pattern, Count) :-
        aggregate_all(count, file_contains(File, Pattern), Count).

*/

/*
calcul(A) :-
		game(A,L),
		somme(L,B,R,G),
		R =< 12,
		G =< 13,
		B =< 14,
		write('Le jeux '), write(A), write(' a : '),
		write(B), write(' bleu, '),
		write(R), write(' rouge, '),
		write(G), write(' vert'), nl.

somme([],B,R,G) :- 
		B is 0,
		R is 0,
		G is 0.
		
somme([H|T],B,R,G) :- 
		somme2(H,B1,R1,G1),
		somme(T,B2,R2,G2), 
		B is B1 + B2,
		R is R1 + R2,
		G is G1 + G2.
		

somme2([],B,R,G) :- 
		B is 0,
		R is 0,
		G is 0.
		
somme2([cube(X,blue)|T],B,R,G) :- 
		somme2(T,B1,R,G),
		B is X + B1.
		

somme2([cube(X,red)|T],B,R,G) :- 
		somme2(T,B,R1,G),
		R is X + R1.
		
	
somme2([cube(X,green)|T],B,R,G) :- 
		somme2(T,B,R,G1),
		G is X + G1.
		
		
calcul2(N) :- 
		findall(A, calcul(A), R),
		somme3(R,N).
		
		
somme3([],R) :- R is 0.
somme3([H|T],R) :- 
		somme3(T,R2),
		R is H + R2.

*/