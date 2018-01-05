/*  Supprime toutes les occurrences de X de L1 pour obtenir L2.*/


supprimer(X,[],[]).
supprimer(X,[X|R],R1):-
    supprimer(X,R,R1).
supprimer(X,[Y|R],[Y|R1]):-
    supprimer(X,R,R1).
