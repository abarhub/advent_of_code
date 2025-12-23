/*
:- set_prolog_flag(double_quotes, chars).
*/

seq([])     --> [].
seq([E|Es]) --> [E], seq(Es).

seqq([]) --> [].
seqq([Es|Ess]) -->
        seq(Es),
        seqq(Ess).

/*
phrase(("Hello, ",seq(Cs),"!"), "Hello, all!").

phrase(seqq(["ab","cd","ef"]), Ls).
*/