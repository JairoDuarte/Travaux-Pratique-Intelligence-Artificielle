
:- include("../outils.pl").
:- include("liste.pl").
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

/* premiere version */
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