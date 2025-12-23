/*
https://www.metalevel.at/prolog/dcg

:- set_prolog_flag(double_quotes, chars).
*/


expr --> num.
expr --> num, [+], expr.
expr --> num, [-], expr.
num --> [D], {number(D)}.

expr-complete(L) :- expr(L, []).

/*


phrase(expr, "5").



expr-complete([11, +, 2, -, 7]).
expr-complete([11, +, 2, -]).



*/