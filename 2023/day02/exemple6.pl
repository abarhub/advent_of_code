/*
https://www.metalevel.at/prolog/dcg

:- set_prolog_flag(double_quotes, chars).
*/


expr(Z) --> num(Z).
expr(Z) --> num(X), [+], expr(Y), {Z is X+Y}.
expr(Z) --> num(X), [-], expr(Y), {Z is X-Y}.
num(D) --> [D], {number(D)}.

expr_value(L, V) :- expr(V, L, []).

/*


phrase(expr, "5").



expr_value([11, +, 2, -, 7], V).

expr_value([8, -, 6, -, 2], V).


*/