/*
https://www.metalevel.at/prolog/dcg

:- set_prolog_flag(double_quotes, chars).
*/

reversal([]) --> [].
reversal([L|Ls]) --> reversal(Ls), [L].

palindrome --> [].
palindrome --> [_].
palindrome --> [E], palindrome, [E].


tree_nodes(nil) --> [].
tree_nodes(node(Name, Left, Right)) -->
        tree_nodes(Left),
        [Name],
        tree_nodes(Right).

tree_nodes2(nil, Ls, Ls) --> [].
tree_nodes2(node(Name, Left, Right), [_|Ls0], Ls) -->
        tree_nodes2(Left, Ls0, Ls1),
        [Name],
        tree_nodes2(Right, Ls1, Ls).

num_leaves(Tree, N) :-
        phrase(num_leaves_(Tree), [0], [N]).

num_leaves_(nil), [N] --> [N0], { N is N0 + 1 } .
num_leaves_(node(_,Left,Right)) -->
        num_leaves_(Left),
        num_leaves_(Right).

/*
phrase(reversal("abcd"), Ls).

phrase(palindrome, "hellolleh").

phrase(tree_nodes(node(a, node(b, nil, node(c, nil, nil)), node(d, nil, nil))), Ns).

Ns = "abcd", phrase(tree_nodes2(Tree, Ns, _), Ns).

num_leaves(node(a,node(b,nil,nil), node(c,nil, node(d,nil,nil))), N).

*/