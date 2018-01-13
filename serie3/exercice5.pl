
/* deuxième version  */
rue(X) :-
    Rue = [maison(C1,N1,S1),maison(C2,N2,S2),maison(C3,N3,S3)],
    
    suppr(C1,[blanc,blue,vert],Cc1),
    suppr(C2,Cc1,Cc2),
    suppr(C3,Cc2,_),

    suppr(N1,[marocaine,algerienne,tunisienne],Nn1),
    suppr(N2,Nn1,Nn2),
    suppr(N3,Nn2,_),

    suppr(S1,[football,boxe,tennis],Ss1),
    suppr(S2,Ss1,Ss2),
    suppr(S3,Ss2,_),

    membre(maison(vert,_,boxe),Rue),
    precede(maison(vert,_,_),maison(_,algerienne,_),Rue),
    membre(maison(blanc,marocaine,_),Rue),
    precede(maison(blanc,_,_),maison(_,_,football),Rue),
    debut(maison(_,_,tennis),Rue),
    X=Rue.

precede(X,Y,[X|R]) :- membre(Y,R).
precede(X,Y,[_|R]):-
    precede(X,Y,R).

debut(X,[X|R]).


rue_v1(X) :-
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