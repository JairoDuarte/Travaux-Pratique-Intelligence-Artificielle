:- include("../outils.pl").
:- include("../serie3/liste.pl").

/* --------------------- Exemples d'états initial --------- */
% Eo = [n,n,n,[],b,b,b]

% etat_initial(). 
/* ------------------ Test de but ------------------- */

test_but([b,b,b,[],n,n,n]).

/* ------------------- Relation successeur ------------- */
% succ(+E1,-E2)
/*------------------------------------------------------*/
succ(E1,E2) :-
    deplacer(E1,E2).

%avancer
deplacer(L1,L2) :-
    nieme(X,[],L1), I is X+1,
    nieme(I,b,L1),
    substituer(X,1,b,L1,L),
    substituer(I,1,[],L,L2).

%avancer
deplacer(L1,L2) :-
    nieme(X,[],L1), I is X-1,
    nieme(I,n,L1),
    substituer(X,1,n,L1,L),
    substituer(I,1,[],L,L2).

%sauter
deplacer(L1,L2) :-
    nieme(X,[],L1), I is X-2,
    nieme(I,n,L1),
    substituer(X,1,n,L1,L),
    substituer(I,1,[],L,L2).

%avancer
deplacer(L1,L2) :-
    nieme(X,[],L1), I is X+2,
    nieme(I,b,L1),
    substituer(X,1,b,L1,L),
    substituer(I,1,[],L,L2).


/* substituer(N,N,X,L1, L2). substituer l'élément dans la position N par la valeur de X dans la liste L1 et retourner la liste L2.   */
substituer(N,N,X,[_|R],[X|R]).
substituer(N,I,X,[Y|R],[Y|Rf]) :-
	I1 is I +1,
	substituer(N,I1,X,R,Rf).


/*----------------------------------------------------------------------
	Programme : dfs_ts.pl

Algorithme de Recherche en profondeur sans détection de cycles
	Depth First Search - Tree Search
	
	dfs_ts(Etat_initial, Chemin_Sol) :
		Chemin_Sol est le chemin de Etat_initial a l'état final
-----------------------------------------------------------------------
Utilise les prédicats correspondants au problème à résoudre suivants :
	test_but(Etat)
		est vrai si Etat est l'état final (état but)

	succ(Etat1, Etat2)
		relation successeur : Etat2 est un successeur de Etat1
 ---------------------------------------------------------------------*/
solution(E1, Ch_Sol) :-
	dfs_ts(E1, Ch_Sol).

solution(E1) :-
	dfs_ts(E1, Ch_Sol),
    afficher(Ch_Sol).
 
dfs_ts(Ef, [Ef]) :-
	test_but(Ef).

dfs_ts(E1,[E1|Ch1]) :-
	succ(E1, E2),
	dfs_ts(E2, Ch1).

/* Test 
?- solution([n,n,n,[],b,b,b]).
[n,n,n,[],b,b,b]
[n,n,n,b,[],b,b]
[n,n,[],b,n,b,b]
[n,[],n,b,n,b,b]
[n,b,n,[],n,b,b]
[n,b,n,b,n,[],b]
[n,b,n,b,n,b,[]]
[n,b,n,b,[],b,n]
[n,b,[],b,n,b,n]
[[],b,n,b,n,b,n]
[b,[],n,b,n,b,n]
[b,b,n,[],n,b,n]
[b,b,n,b,n,[],n]
[b,b,n,b,[],n,n]
[b,b,[],b,n,n,n]
[b,b,b,[],n,n,n]

*/
