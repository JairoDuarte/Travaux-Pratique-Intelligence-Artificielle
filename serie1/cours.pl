date(1,2,2015).
point(a1,a2). 
segement(point(1,2),point(1,3)). 
etudiant(nom,prenom,date(j,m,a),cne).

somme(X,Y,Z) :-
    Z= +(X,Y).

fact(0,1). 
fact(N,M) :- 
    N > 0, 
    N1 is N-1, 
    fact(N1,M1), 
    M is N*M1.


max(X, Y, X):-
    X >= Y. 

max(X, Y, X):- 
    X < Y.

max2(X, Y, X):- 
    X >= Y.
max2(X, Y, Y).

% Extraction du premier élément de la liste 

premier([Premier|_],Premier).

% Extraction du reste de la liste 

reste([_,_|Reste], Reste).

longueur([],0). 
longueur([_|R], N) :- 
    longueur(R,Nr), N is Nr + 1.

conc([], L, L). 
conc([X|R1], L2, [X|R]) :-
    conc(R1,L2,R).