:- include("../outils.pl").
:- include("../serie3/liste.pl").

/* --------------------- Exemples d'états initial --------- */
% Eo = [[disque(1),disque(4),disque(4)],[],[]]

% etat_initial([[disque(1),disque(4),disque(5)],[],[]]). 
/* ------------------ Test de but ------------------- */

test_but([[],[],[disque(1),disque(4),disque(5)]]).

/* ------------------- Relation successeur ------------- */
% succ(+E1,-E2)
/*------------------------------------------------------*/
succ([L1,L2,L3],[NL1,NL2,NL3]) :-
    L1 \= [],
    deplacer(L1,N,NL1),conc(N,L2,NL2),
    NL3 = L3;
    L1 == [], NL1 = [], L2 \= [],
    deplacer(L2,N,NL2),
    conc(N,L3,NL3).

dis([L1,L2,L3],L1,L2,L3).
/* deplacer(+L1,-L2,-L3) : L2 liste avec le premier élément de L1  , L3 liste avec les reste des éléments de L1   */
deplacer([X],[X],[]).
deplacer([X|R],[X],R).

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


*/
