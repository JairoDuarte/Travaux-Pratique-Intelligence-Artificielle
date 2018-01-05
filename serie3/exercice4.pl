%est_matrice(+M, ?NL, ?NC) Vraie si M est une matrice NLxNC.
/*
col = nbr liste
lig = nbr element dans une col .
exp : L = [[1,2,3],[4,5,6]] col = 2 , lig = 3 
1 4
2 5
4 6
*/
est_matrice([X|R],NL,NC) :-
    longueur([X|R],NL1),
    longueur(X,NC1),
    NC == NC1,
    NL == NL1.

/*matrice([],[],[]).
matrice([X|R],X,R).
matrice([X|R],L,R1) :-
    matrice(R,L,R1).*/

%transposee(?M, ?TM) TM est la matrice transposée de la matrice M.

transposee([],[]).
transposee([X|R],RF) :-
    m_l(X,T),
    transposee(R,RM),
    m_c(T,RM,RF),!.

/* retourne le transposée d'un  vecteur 
ex: L1 = [1,2,3] , resultat = [[1],[2],[3]]
*/
m_l([],[]).
m_l([X|R],RS) :-
    m_l(R,T),
    conc([[X]],T,RS).

/* concatene les lignes de deux matrices de sorte qu'on ait une matrice  
ex: L1 = [[1],[2],[3]] ; L2 = [[4],[5],[6]] ; Resultat = [[1,4],[2,5],[3,6]]
 */
m_c([],[],[]).
m_c(T,[],T).
m_c([X1|R1],[X2|R2],RF) :-
    conc(X1,X2,X3),
    m_c(R1,R2,R3),
    conc([X3],R3,RF).
    

%pscalaire(+U, +V, -P) P est le produit scalaire de U et V.
pscalaire([],_,[]).
pscalaire([X|R],V,[P|RF]) :-
    P is X*V,
    pscalaire(R,V,RF).


%produit_mv(+M, +U, -V) V est le vecteur produit de la matrice M par le vecteur U.
produit_mv([],[],[]).
produit_mv([X|R],[Y|Z],RF) :-
    pscalaire(X,Y,M),
    produit_mv(R,Z,RS),
    somme_ligne(M,RS,RF).

/* retourne la somme de chaque element de deux lignes */
somme_ligne(T,[],T).
somme_ligne([X|R],[Y|Z],[RS|RF]) :-
    RS is X+Y,
    somme_ligne(R,Z,RF).

%produit_m(M1, M2, M) M est le produit des deux matrices M1 et M2.
produit_m(_,[],[]).
%produit_m([],[],[]).
produit_m(M1,[X|R],RF) :-
    produit_mv(M1,X,Y),
    produit_m(M1,R,Z),
    conc([Y],Z,RF).

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