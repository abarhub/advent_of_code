
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

