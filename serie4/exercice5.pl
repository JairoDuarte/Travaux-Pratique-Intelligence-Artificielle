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
    deplacer(L1,L2,L3,NL1,NL2,NL3).
    /* L1 = [],
    deplacer(L1,N,NL1),conc(N,L2,NL2),
    NL3 = L3;
    L1 == [], NL1 = [], L2 = [],
    deplacer(L2,N,NL2),
    conc(N,L3,NL3). */

deplacer([X|R],[],[],R,[X],[]). %
deplacer([X|R],[],L,R,[X],L). %
deplacer([disque(X)|R],[disque(Y)|R1],[], R,[disque(Y)|R1],[disque(X)]) :- %
    X > Y.
deplacer([disque(X)|R],[disque(Y)|R1],[], [disque(Y),disque(X)|R],R1,[]) :- %
    X > Y.
deplacer([disque(X)|R],[disque(Y)|R1],[disque(Z)|R2], R,[disque(Y)|R1],[disque(X),disque(Z)|R2]) :-
    X > Y, X < Z.

deplacer([disque(X)|R],[disque(Y)|R1],[disque(Z)|R2], [disque(X)|R],R1,[disque(Y),disque(Z)|R2]) :-
    X > Y, Y < Z. %
deplacer([X],[],[disque(Z)|R2],[],[X],[disque(Z)|R2]). %
deplacer([],L,[Z],[Z],L,[]). %
%deplacer(L,[Y],[],L,[],[Y]). %

deplacer([],[disque(Y)|R1],[disque(Z)|R2],[],R1,[disque(Y),disque(Z)|R2]) :-
   Z > Y.
%deplacer([],[disque(Y)|R1],[disque(Z)|R2],[],[disque(Z),disque(Y)|R1],R2) :-
 %    Y < Z. %
     
%deplacer([disque(X)|R],[disque(Y)|R1],[disque(Z)|R2],[disque(X)|R],[R1],[disque(Y),disque(Z)|R2]) :-
 %   X < Y,Y<Z.
%deplacer([X],[],[disque(Z)|R2],[],[],[X,disque(Z)|R2]).

%deplacer([disque(X)|R],[disque(Y)|R1],[],[disque(X)|R],R1,[disque(Y)]) :-
 %   X < Y.


dis([L1,L2,L3],L1,L2,L3).
/* deplacer(+L1,-L2,-L3) : L2 liste avec le premier élément de L1  , L3 liste avec les reste des éléments de L1   */
deplacer([X],[X],[]).
deplacer([X|R],[X],R).

/*----------------------------------------------------------------------
	Programme : dfs_id.pl

Recherche en profondeur itérée avec détection des cycles
	Iterative Deeping Depth First Search

	dfs_id(Etat_initial, Chemin_Sol)
		Chemin_Sol est le chemin de l'étatl initial à l'état final (but)

	chemin(E1, E2, Chemin)
		Chemin est le chemin acyclique entre E1 et E2 
		
NB. les chemins sont dans l'ordre inverse
-----------------------------------------------------------------------
Utilise les prédicats correspondants au problème à résoudre suivants :
	test_but(Etat)
		est vrai si Etat est l'état final (état but)

	succ(Etat1, Etat2)
		relation successeur : Etat2 est un successeur de Etat1

l'algorithme procède de la forme suivante : cherche le successeur n+1 ensuite le n et il répété jusqu'à la dernière profondeur. 
exemple: 

E0 = [3,2,1]  & Ef = [1,2,3]

it n=1 :  E2 = [2,3,1], E1 = [2,1,3];   E1 /= Ef  donc on refait avec n= n+1 itération 
it n=2 :  E3 = [2,3,1], E2 = [2,1,3],   E1 = [1,2,3] ; E1 = Ef donc état final atteint, on termine la recherche.
 ---------------------------------------------------------------------*/

dfs_id(E0, Chemin_Sol) :-
	chemin(E0, Ef, Chemin_Sol),
	test_but(Ef).

chemin(Etat, Etat, [Etat]).		% chemin de Etat vers Etat est [Etat]	

chemin(E1, E2, [E2|Chemin]) :-
	chemin(E1, E3, Chemin),
	succ(E3, E2),
	not(membre(E2, Chemin)).		% eviter le cycle

solution_dfs(E0) :-
	dfs_id(E0, S),
	inverser(S, Sol),
	afficher(Sol).

/*----------------------------------------------------------------------
	Programme : bfs.pl
	Recherche en largeur d'abord avec détection de cycles
	Breadth First Search

	On represente un noeud : noeud(Etat,Chemin)
		où Etat est l'état correspondant au noeud et Chemin est le
		chemin qui mène de l'état initial à cet état.
		Les chemins sont donnés dans l'ordre inverse
	
	Le noeud initial est : noeud(E0, [])
		E0 est l'état initial
	
	bfs(E0, Chemin_Sol)
		Chemin_Sol est le chemin de l'état initial E0 à l'état final (but)

	chercher(Candidats, Chemin_Sol)
            est vraie si Chemin_Sol est une extension d'un chemin d'un élément de
            Candidats
            Candidats est la liste des noeuds candidats

	developper(Noeud, LstSucc) 
			LstSucc est la liste des noeuds successeurs de Noeud
			le developpement ecarte les chemins cycliques

-----------------------------------------------------------------------
Utilise les prédicats correspondants au problème à résoudre suivants :
	test_but(Etat)
		est vrai si Etat est l'état final (état but)

	succ(Etat1, Etat2)
		relation successeur : Etat2 est un successeur de Etat1
 ---------------------------------------------------------------------*/

% Noeud initial est [Etat_initial]
solution_bfs(E0, Chemin_Sol) :-
	bfs([noeud(E0, [])], Chemin_Sol).

% Si le premier candidat est le noeud final
bfs([noeud(Etat,Chemin)|_], [Etat|Chemin]) :-
	test_but(Etat).
	
% Sinon developper le noeud et ajouter ses successeurs à la fin de la liste des candidats
bfs([N|Candidats], Chemin_Sol) :-
	developper(N, LstSucc),
	conc(Candidats, LstSucc, Candidats_1),
	bfs(Candidats_1, Chemin_Sol).

% developper
developper(noeud(E,Chemin), LstSucc) :-
	setof(noeud(E1, [E|Chemin]),
	      ( succ(E, E1), not( membre(E1, [E|Chemin]) ) ),
	       LstSucc),
	!.

developper(_N, []).	% Si le noeud n'a pas de successeur

solution_bfs(E0) :-
	solution_bfs(E0, S),
	inverser(S, Sol),
	afficher(Sol).


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
