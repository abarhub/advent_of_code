/*
https://stackoverflow.com/questions/27878382/how-to-do-a-parser-in-prolog

:- set_prolog_flag(double_quotes, chars).
*/

parser([]) --> [].
parser(Tree) --> assign(Tree).

assign(assignment(ident(X), '=', Exp)) --> id(X), [=], expr(Exp), [;].

id(X) --> [X], { atom(X) }.

expr(expression(Term)) --> term(Term).
expr(expression(Term, Op, Exp)) --> term(Term), add_sub(Op), expr(Exp).

term(term(F)) --> factor(F).
term(term(F, Op, Term)) --> factor(F), mul_div(Op), term(Term).

factor(factor(int(N))) --> num(N).
factor(factor(Exp)) --> ['('], expr(Exp), [')'].

add_sub(Op) --> [Op], { memberchk(Op, ['+', '-']) }.
mul_div(Op) --> [Op], { memberchk(Op, ['*', '/']) }.

num(N) --> [N], { number(N) }.


main :-
    open('test2.txt', read, Str),
    read_file(Str,Lines),
    close(Str),
    write(Lines), nl.

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_file(Stream,L).

:- use_module(library(pio)).

lines([])           --> call(eos), !.
lines([Line|Lines]) --> line(Line), lines(Lines).

eos([], []).

line([])     --> ( "\n" ; call(eos) ), !.
line([L|Ls]) --> [L], line(Ls).


test1(File) :-
	open(File, read, Input),
	read_line_to_string(Input, S),
	write('ligne:'),write(S),
	close(Input).

/*
parcourt()
*/

stream_lines0(File,Lines) :-
	open(File, read, Input),
	stream_lines(Input,Lines),
	close(Input).
	

stream_lines(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "\n", Lines).


/*


phrase(parser(T), [a, =, 3, +, '(', 6, *, 11, ')', ;]).



https://stackoverflow.com/questions/66840573/program-in-swi-prolog


https://www.swi-prolog.org/pldoc/doc_for?object=read_util:read_line_to_string/2


https://swi-prolog.discourse.group/t/read-lines-of-stdin-until-eof-into-a-list/6502

*/