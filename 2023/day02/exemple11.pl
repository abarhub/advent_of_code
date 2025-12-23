

:- set_prolog_flag(double_quotes, chars).




:- use_module(library(pio)).


/*
Lit les lignes du fichier
*/
stream_lines0(File,Lines) :-
	open(File, read, Input),
	stream_lines(Input,Lines),
	close(Input).
	

stream_lines(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "\n", Lines).

/*
parse les lignes
*/
parseLines([], []).

parseLines([H|T], [R2|T2]) :- 
				/*write('H:'),write(H),nl,*/
				string_chars(H, H2),
				/*write('H2:'),write(H2),nl,
				write('T:'),write(T),nl,*/
				phrase(parseGame(R2), H2), 
				/*write('res:'),write(R2),nl,*/
				parseLines(T, T2).

/*
définition du parser
*/
parseGame(game(N,List)) --> 
				"Game ", num0(N),deux_point, " ", listeGames(List)  , 
				{write('game:'),write(N),write('liste:'),write(List),nl} 
				.

deux_point --> ":".


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

num0(N) --> num2(N).

listeGames(L) --> listeGames0(L).
			
listeGames0([X|L]) --> 
			listeGames1(X), 
			"; ", 
			/*{write('listeGames,'),write(X),nl}, */
			listeGames0(L).
			
listeGames0([X]) --> 
			listeGames1(X).

listeGames1([X|L]) --> 
			listeGames3(X), 
			", ", 
			/*{write('listeGames,'),write(X),nl}, */
			listeGames1(L).
			
listeGames1([X]) --> 
			listeGames3(X).


listeGames3(X) --> 
			game0(X) 
			.



game0(bleu(N)) --> num0(N), " blue".
game0(rouge(N)) --> num0(N), " red".
game0(vert(N)) --> num0(N), " green".




/*
calcul les jeux qui sont a prendre
*/
calcul02(game(N,List), V, N) :-
		somme00(List,14,12,13,V)
		/*,write('Le jeux '), write(N), write(' a : '),write(V), write(' valeur'),nl*/
		.
	
calculMax([bleu(X)|T],B,R,V) :-
		calculMax(T,B1,R1,V1),
		B is max(X,B1),
		R is R1,
		V is V1
		.
	
calculMax([rouge(X)|T],B,R,V) :-
		calculMax(T,B1,R1,V1),
		B is B1,
		R is max(X,R1),
		V is V1
		.
		
calculMax([vert(X)|T],B,R,V) :-
		calculMax(T,B1,R1,V1),
		B is B1,
		R is R1,
		V is max(X,V1)
		.

calculMax([],B,R,V) :-
		B is 0,
		R is 0,
		V is 0
		.

	
calcul03(game(_,List),cube(B,R,V)) :-
		calcul003(List,B,R,V)		
		.

calcul003([H|T],B,R,V) :-
		calculMax(H,B1,R1,V1),
		calcul003(T,B2,R2,V2),
		B is max(B1,B2),
		R is max(R1,R2),
		V is max(V1,V2)
		.
		
		
calcul003([],B,R,V) :-
		B is 0,
		R is 0,
		V is 0
		.


calcul04([H|T],R2) :-
		calcul03(H,cube(B,R,V)),
		N is B*R*V,
		calcul04(T,R3),
		R2 is R3+N
		.
		
calcul04([],0).
	
calcul00(L, N) :- 
		calcul0(L,N)
		/*,write('N'),write(N),nl*/
		.


	
calcul0([H|T], N) :- calcul02(H, N0, N2), calcul0(T, N1), N3 is (1-N0)*N2, N is N3+N1.
calcul0([H], N) :- calcul02(H, N0, N2), N is (1-N0)*N2.


somme00(L,BM,RM,GM,N) :-
		somme01(L,BM,RM,GM,N).

somme01([H|T],BM,RM,GM,N3) :-
		somme02(H,B,R,G),
		a_prendre(B,R,G,BM,RM,GM,N1),
		/*write('jeu '),write(N),write('B'),write(B),write('R'),write(R),write('G'),write(G),write('N'),write(N),nl,*/
		somme01(T,BM,RM,GM,N2),
		N3 is max(N1,N2)
		.


somme01([H],BM,RM,GM,N2) :-
		somme02(H,B,R,G),
		a_prendre(B,R,G,BM,RM,GM,N2)
		.

a_prendre(A,B,C,A2,B2,C2, N) :-
		A=<A2,
		B=<B2,
		C=<C2,
		N is 0.
		
		
a_prendre(_,_,_,_,_,_, N) :-
		N is 1.
		
		

		
somme02([H|T],B,R,G) :-
		somme2(H,B1,R1,G1),
		somme02(T,B2,R2,G2), 
		B is B1 + B2,
		R is R1 + R2,
		G is G1 + G2
		.
		
somme02([H],B,R,G) :-
		somme2(H,B,R,G)
		.		


		
somme2(bleu(X),B,0,0) :- 
		B is X.
		

somme2(rouge(X),0,R,0) :-
		R is X.
		
	
somme2(vert(X),0,0,G) :- 
		G is X.
		
	



/*
lit le fichier et affiche le résultat du parsing
*/
parse0(File, R) :- 
		stream_lines0(File, Lines),
		/*write('Lines du fichier : '), write(Lines), nl, */
		parseLines(Lines, R).

/*
Lit le fichier et calcul le résultat
*/
parse1(File, R) :- 
		stream_lines0(File, Lines),
		/*write('Lines du fichier : '), write(Lines), nl, */
		parseLines(Lines, R0),
		/*calcul(R0, R)*/
		write('Listes : '), write(R0), nl,
		calcul04(R0, R)
		.

/*
execution de la solution
*/

main :-
    parse1('test_advent_of_code_2023_day2_part1.txt', X),
    write('resultat:'),write(X), nl.

/*

pour l'executer :
working_directory(_, 'chemin_vers_le_repertoire_du_fichier_test_advent_of_code_2023_day2_part1.txt').
main.

La solution est 66027


*/