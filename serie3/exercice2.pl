p(X,Y):- X @=< Y.

/* qui est vrai si la liste L est triée selon l'ordre donné par le prédicat p. */

% [X,Y|R] .

est_trie([]).
est_trie([X|R]):-
    element(R,Y),
    p(X,Y),
    est_trie(R).

min_liste(X,[X,Y]):-p(X,Y),!.
min_liste(Y,[X,Y]):-p(Y,X),!.
min_liste(Min, [X|R]):-
    element(R,Y),min_liste(Min1,R),min_liste(Min2,[X,Y]),
    p(Min1,Min2),Min = Min1,!;
    element(R,Y),min_liste(Min1,R),min_liste(Min2,[X,Y]),
    p(Min2,Min1),Min = Min2,!.

element([X|_],X).
element([],[]).

/*
in_liste([],[]).
min_liste(Min, [X|R]):-
    element(R,Y),min_liste(Min,R),min_liste(Min1,[X,Y])
    p(X,Y),p(X,Min),Min = X;
    
    element(R,Y),min_liste(Min,R),
    p(Y,X),p(Y,Min),Min = Y;
*/