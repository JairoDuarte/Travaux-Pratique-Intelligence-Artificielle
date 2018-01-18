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
solution(E0, Ch_Sol) :-
	dfs_ts(E0, Ch_Sol).
 
dfs_ts(Ef, [Ef]):-
	test_but(Ef).

dfs_ts(E, [E|Ch1]) :-
	succ(E, E1),
	dfs_ts(E1, Ch1).