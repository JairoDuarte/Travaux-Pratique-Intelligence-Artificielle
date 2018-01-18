:- include("../outils.pl").
:- include("../serie3/liste.pl").

/* --------------------- Exemples d'états initial --------- */
% une liste quelconque d intiers 
etat_initial([25,5,2,3,4,10]). 
/* ------------------ Test de but ------------------- */

test_but(Ef,Nbr) :- 
    membre(Nbr,Ef).

/* ------------------- Relation successeur ------------- */
% succ(+E1,-E2,-Op)
/*------------------------------------------------------*/
succ(L,[Z|Rss],Op) :-
    suppr(X,L,Rs),
    suppr(Y,Rs,Rss),
    operation(X,Y,Z,Op),
    Z =\= 0 .

operation(X,Y,Z,X*Y) :- Z is X*Y.
operation(X,Y,Z,X+Y) :- Z is X+Y.
operation(X,Y,Z,X/Y) :- X > Y, Z is X//Y.
operation(X,Y,Z,X-Y) :- X > Y, Z is X-Y.
operation(X,Y,Z,Y-X) :- Y > X, Z is Y - X, X mod Y == 0.
operation(X,Y,Z,Y/X) :- Y > X, Z is Y//X, Y mod X =:= 0.


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
solution(Nbr,E1, Ch_Sol) :-
	dfs_ts(Nbr, E1, Ch_Sol).

solution(Nbr,E1) :-
	dfs_ts(Nbr, E1, Ch_Sol),
    afficher(Ch_Sol).
 
dfs_ts(Nbr, Ef, [Ef]):-
	test_but(Ef,Nbr),
    write([Ef]),nl.

dfs_ts(Nbr, E1,[Op|Ch1]) :-
	succ(E1, E2,Op),
	dfs_ts(Nbr,E2, Ch1).

/* Test 

?- solution(347,[25,7,4,2,3]).
25*7
175*4
700/2
350-3
[347]
true .



*/
