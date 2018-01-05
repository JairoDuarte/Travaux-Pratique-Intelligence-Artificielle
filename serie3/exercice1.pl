

/* Vraie si X est le N-ieme élément de la liste L. */

nieme(1,X,[X|_]).
nieme(N,X,[_|R]):- nieme(N1,X,R),
    N is N1+1. % on fait une comparaison si la valeur dans N est égal au resultat de N1+1.

/* N est le nombre d occurrence de X dans L. nb_occur(X, N, [a,b,a,c,b,a]).  */

nb_occur(_,0,[]):-!.
nb_occur(X,N,[X|R]):-%suppr(X,R,L),
    nb_occur(X,N1,R),
    N is N1 +1.

nb_occur(X,N,[Y|R]):-
    nb_occur(X,N,R),
    X\==Y.

/* L est la liste créée à partir de N occurrences du terme X. */

creerListe(X,N,L):-.


/* L2 est la liste inverse de L1. */

inverser([],[]).
/*inverser([X|R],[R1|X]):-
    inverser(R,R1).*/
inverser([X|R],L) :-
    inverser(R,R1),
    conc(R1,[X],L).

/* Substituer toutes les occurrences de X par Y dans L1 pour obtenir L2. */

%substituer(X,Y,L1,L2).
substituer(X,Y,[X|R],[Y|R]).
substituer(X,Y,[Z|R],[Z|R1]):-
    substituer(X,Y,R,R1). 


/* Ld est la liste L où les éléments ont été décalés circulairement vers la droite.*/

%decaler(L,Ld).
decaler([],[]).
decaler(L,[X|R]):- 
    conc(R,[X],L).

/* Qui donne une permutation P de la liste L. 
permuter([a,b,c],P). 
P = [a, b, c] ; 
P = [b, a, c] ; 
P = [b, c, a] ; 
P = [a, c, b] ; 
P = [c, a, b] ; 
P = [c, b, a] ; 
false.
*/
permuter([],[]).
permuter([X|R],A):-
    permuter(R,R1),
    insert(X,R1,A).


/*
LL est une liste de listes. L est la liste LL qui ne contient plus qu’un seul 
niveau de crochets.
*/


%aplatir(LL,L). -
aplatir([],[]).
aplatir(T,[T]):- 
    T\= [_|_],
    T\= [].
aplatir([X|R],L):-
    aplatir(X,X1),
    aplatir(R,R1),
    conc(X1,R1,L).

apla([X|R],X,R). %:- L is X.


