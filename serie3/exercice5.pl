
rue(X) :-
    Rue = [maison(C1,_,tennis),maison(C2,_,_),maison(C3,_,_)],
    suppr(C1,[blanc,blue,vert],Cc1),
    suppr(C2,Cc1,Cc2),
    suppr(C3,Cc2,_),
    membre(maison(vert,_,boxe),Rue),
    precede(maison(vert,_,_),maison(_,algerienne,_),Rue),
    precede(maison(blanc,_,_),maison(vert,_,_),Rue),
    membre(maison(blanc,marocaine,_),Rue),
    %membre(maison(_,_,tennis),Rue),
    membre(maison(_,tunisienne,_),Rue),
    membre(maison(_,_,football),Rue),
    X=Rue.

precede(X,Y,[X,Y|_]).
precede(X,Y,[_|R]):-
    precede(X,Y,R).


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