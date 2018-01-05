/* On représente les ensembles par des listes sans doublons. Ecrire les procédures suivantes :*/

%Vrai si L représente un ensemble

ensemble([_]):-!.
ensemble([X,Y|R]):-
    X\==Y,
    ensemble([Y|R]).
/*
ensemble([X,R]):- 
    not(membre(X,R)),
    ensemble(R).
    */

/* creer_ensemble(+L, -E) E est l'ensemble crée à partir de la liste L. */

creer_ensemble([],[]).
creer_ensemble([X|R],[X|L]):-
    supprimer(X,R,R1),
    creer_ensemble(R1,L),!.


/* sous_ensemble(?SE, +E) SE est un sous-ensemble de E. */
sous_ensemble([],_).
sous_ensemble([X|R],E) :- 
    membre(X,E),
    sous_ensemble(R,E).
/*  intersection(+E1, +E2, -E) E est l'intersection de E1 et E2. */

intersection([],_,[]).
%intersection(_,[],[]).
intersection([X|R],L,RF):-
    membre(X,L),
    intersection(R,L,R1),
    conc([X],R1,RF);
    intersection(R,L,RF).

/* reunion(+E1, +E2, -E) E est la réunion de E1 et E2. */

reunion(E1,E2,R):-
    conc(E1,E2,R1),
    creer_ensemble(R1,R).

/* difference(+E1, +E2, -E) E = E1 - E2. */

difference([],_,[]).
difference([X1|R1],E2,RS) :-
    not(membre(X1,E2)),
    difference(R1,E2,R2),
    conc([X1],R2,RS);
    difference(R1,E2,RS).


/*------------------------ Les procedures utiles (d'aide) ----------------------------- */

/*  Supprime toutes les occurrences de X de L1 pour obtenir L2.*/


supprimer(_,[],[]).
supprimer(X,[X|R],R1):-
    supprimer(X,R,R1).
supprimer(X,[Y|R],[Y|R1]):-
    supprimer(X,R,R1).

membre(X,[X|_]). 
membre(X,[_|Reste]) :- membre(X,Reste).

conc([], L, L).
conc([X|R1], L2, [X|R]) :-
	conc(R1,L2,R).

% suppr(X,L1,L2) : L2 est L1 privé de X
suppr(X,[X|R],R).
suppr(X,[Y|R],[Y|R1]):-
	suppr(X,R,R1).

%insert(X, L, L1).
insert(X, L, L1) :- suppr(X, L1, L).