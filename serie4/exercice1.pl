:- include("../outils.pl").
:- include("../serie3/liste.pl").

/* --------------------- Exemples d'états initial --------- */
etat_initial([n(1,neutre,[2,3,5,6]),n(2,neutre,[1,3,4,5,6]),n(3,neutre,[1,2,4,6]),n(4,neutre,[2,3,6]),n(5,neutre,[1,2,6]),n(6,neutre,[1,2,3,5])]).

/* ------------------ Test de but ------------------- */

test_but(G) :- 
    not(membre(n(_,neutre,_),G)).

/* ------------------- Relation successeur ------------- */
% succ(+E1,-E2,+Lc)
/*------------------------------------------------------*/
succ(G,[n(S,Cc,La)|R],Lc) :-
    suppr(n(S,neutre,La),G,R),
    couleurs(G,La,L),
    setof(C,membre(C,L),Lca),
    membre(Cc,Lc),
    not(membre(Cc,Lca)).

% test function successeur: succ([n(1,neutre,[2,3,5,6]),n(2,neutre,[1,3,4,5,6]),n(3,neutre,[1,2,4,6]),n(4,neutre,[2,3,6]),n(5,neutre,[1,2,6]),n(6,neutre,[1,2,3,5])],E2,[rouge,jeune,vert,noir]).
/* couleurs(+G,+La,-Lc)   */ 

couleurs(_,[],[]).
couleurs(G,[X|R],[Cc|Rc]) :-    
    suppr(n(X,Cc,_),G,Gr),
    couleurs(Gr,R,Rc).


/*  */
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
solution(Lc,E0, Ch_Sol) :-
	dfs_ts(Lc, E0, Ch_Sol).
    
solution(Lc,E0) :-
	dfs_ts(Lc, E0, Ch_Sol),
    afficher(Ch_Sol).
 
dfs_ts(_, Ef, [Ef]):-
	test_but(Ef).

dfs_ts(Lc, E,[E|Ch1]) :-
	succ(E, E1,Lc),
	dfs_ts(Lc, E1, Ch1).