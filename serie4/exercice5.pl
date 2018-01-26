:- include("../outils.pl").
:- include("../serie3/liste.pl").
/* --------------------- Exemples d'états initial --------- */
% Eo = 
etat_initial([tour(1,[1,2,3,4,5]),tour(2,[]),tour(3,[])]). 
/* ------------------ Test de but ------------------- */

%test_but([tour(1,[]),tour(2,[]),tour(3,[1,2,3])]).
test_but(Ef) :-
    write(Ef),nl,
    membre(tour(3,[1,2,3,4,5]),Ef).

/* ------------------- Relation successeur ------------- */
% succ(+E1,-E2)
/*------------------------------------------------------*/
succ(E1,E2) :-
    suppr(tour(T1,L1),E1,R1),
    suppr(tour(T2,L2),R1,R3),
    T1 \= T2,
    deplacer(L1,L2,NL1,NL2),tour_valide(NL2),
    setof(tour(K,Z),membre(tour(K,Z),[tour(T1,NL1),tour(T2,NL2)|R3]),E2).

succ(E1,E2,["deplacer de la tour ",T1,"vers la tour ",T2]) :-
    suppr(tour(T1,L1),E1,R1),
    suppr(tour(T2,L2),R1,R3),
    T1 \= T2,
    deplacer(L1,L2,NL1,NL2),tour_valide(NL2),
    setof(tour(K,Z),membre(tour(K,Z),[tour(T1,NL1),tour(T2,NL2)|R3]),E2).
    %conc([tour(T2,NL2)],R3,Nt),conc([tour(T1,NL1)],Nt,E2).

tour_valide([_]).
tour_valide([X,Y|_]) :- 
    number(X),number(Y),X<Y.

deplacer([X|R],L2,R,[X|L2]).

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

/* Solution avec action */
dfs_id(E0, Chemin_Sol,Act) :-
	chemin(E0, Ef, Chemin_Sol,Act),
	test_but(Ef).

chemin(Etat, Etat, [Etat],[]).

chemin(E1, E2, [E2|Chemin],[Act|ActP]) :-
	chemin(E1, E3, Chemin,ActP),
	succ(E3, E2,Act),
	not(membre(E2, Chemin)).

solution_dfs_a(E0) :-
    dfs_id(E0, S,Act),
	inverser(S, Sol),
	afficher(Sol),
    write("Actions :"),nl,nl,
    inverser(Act,A),
    afficher(A).

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

/* Test 
?- etat_initial(E),solution_dfs(E).
[tour(1,[1,2,3]),tour(2,[]),tour(3,[])]
[tour(1,[2,3]),tour(2,[]),tour(3,[1])]
[tour(1,[3]),tour(2,[2]),tour(3,[1])]
[tour(1,[3]),tour(2,[1,2]),tour(3,[])]
[tour(1,[]),tour(2,[1,2]),tour(3,[3])]
[tour(1,[1]),tour(2,[2]),tour(3,[3])]
[tour(1,[1]),tour(2,[]),tour(3,[2,3])]
[tour(1,[]),tour(2,[]),tour(3,[1,2,3])]

?- etat_initial(E),solution_bfs(E).
[tour(1,[1,2,3]),tour(2,[]),tour(3,[])]
[tour(1,[2,3]),tour(2,[]),tour(3,[1])]
[tour(1,[3]),tour(2,[2]),tour(3,[1])]
[tour(1,[3]),tour(2,[1,2]),tour(3,[])]
[tour(1,[]),tour(2,[1,2]),tour(3,[3])]
[tour(1,[1]),tour(2,[2]),tour(3,[3])]
[tour(1,[1]),tour(2,[]),tour(3,[2,3])]
[tour(1,[]),tour(2,[]),tour(3,[1,2,3])]

?- etat_initial(E),solution_dfs_a(E).
[tour(1,[1,2,3]),tour(2,[]),tour(3,[])]
[tour(1,[2,3]),tour(2,[]),tour(3,[1])]
[tour(1,[3]),tour(2,[2]),tour(3,[1])]
[tour(1,[3]),tour(2,[1,2]),tour(3,[])]
[tour(1,[]),tour(2,[1,2]),tour(3,[3])]
[tour(1,[1]),tour(2,[2]),tour(3,[3])]
[tour(1,[1]),tour(2,[]),tour(3,[2,3])][tour(1,[]),tour(2,[]),tour(3,[1,2,3])]
Actions :

[deplacer de la tour ,1,vers la tour ,3]
[deplacer de la tour ,1,vers la tour ,2]
[deplacer de la tour ,3,vers la tour ,2]
[deplacer de la tour ,1,vers la tour ,3]
[deplacer de la tour ,2,vers la tour ,1]
[deplacer de la tour ,2,vers la tour ,3]
[deplacer de la tour ,1,vers la tour ,3]

Solution d'une tour avec 5 disques, ça a fait plus d'une heure pour trouver la solution.

?- etat_initial(E),solution_dfs_a(E).
tour(1,[1,2,3,4,5]),tour(2,[]),tour(3,[])]
[tour(1,[2,3,4,5]),tour(2,[]),tour(3,[1])]
[tour(1,[3,4,5]),tour(2,[2]),tour(3,[1])]
[tour(1,[3,4,5]),tour(2,[1,2]),tour(3,[])]
[tour(1,[4,5]),tour(2,[1,2]),tour(3,[3])]
[tour(1,[1,4,5]),tour(2,[2]),tour(3,[3])]
[tour(1,[1,4,5]),tour(2,[]),tour(3,[2,3])]
[tour(1,[4,5]),tour(2,[]),tour(3,[1,2,3])]
[tour(1,[5]),tour(2,[4]),tour(3,[1,2,3])]
[tour(1,[5]),tour(2,[1,4]),tour(3,[2,3])]
[tour(1,[2,5]),tour(2,[1,4]),tour(3,[3])]
[tour(1,[1,2,5]),tour(2,[4]),tour(3,[3])]
[tour(1,[1,2,5]),tour(2,[3,4]),tour(3,[])]
[tour(1,[2,5]),tour(2,[3,4]),tour(3,[1])]
[tour(1,[5]),tour(2,[2,3,4]),tour(3,[1])]
[tour(1,[5]),tour(2,[1,2,3,4]),tour(3,[])]
[tour(1,[]),tour(2,[1,2,3,4]),tour(3,[5])]
[tour(1,[1]),tour(2,[2,3,4]),tour(3,[5])]
[tour(1,[1]),tour(2,[3,4]),tour(3,[2,5])]
[tour(1,[]),tour(2,[3,4]),tour(3,[1,2,5])]
[tour(1,[3]),tour(2,[4]),tour(3,[1,2,5])]
[tour(1,[3]),tour(2,[1,4]),tour(3,[2,5])]
[tour(1,[2,3]),tour(2,[1,4]),tour(3,[5])]
[tour(1,[1,2,3]),tour(2,[4]),tour(3,[5])]
[tour(1,[1,2,3]),tour(2,[]),tour(3,[4,5])]
[tour(1,[2,3]),tour(2,[]),tour(3,[1,4,5])]
[tour(1,[3]),tour(2,[2]),tour(3,[1,4,5])]
[tour(1,[3]),tour(2,[1,2]),tour(3,[4,5])]
[tour(1,[]),tour(2,[1,2]),tour(3,[3,4,5])]
[tour(1,[1]),tour(2,[2]),tour(3,[3,4,5])]
[tour(1,[1]),tour(2,[]),tour(3,[2,3,4,5])]
[tour(1,[]),tour(2,[]),tour(3,[1,2,3,4,5])]
Actions :

[deplacer de la tour ,1,vers la tour ,3]
[deplacer de la tour ,1,vers la tour ,2]
[deplacer de la tour ,3,vers la tour ,2]
[deplacer de la tour ,1,vers la tour ,3]
[deplacer de la tour ,2,vers la tour ,1]
[deplacer de la tour ,2,vers la tour ,3]
[deplacer de la tour ,1,vers la tour ,3]
[deplacer de la tour ,1,vers la tour ,2]
[deplacer de la tour ,3,vers la tour ,2]
[deplacer de la tour ,3,vers la tour ,1]
[deplacer de la tour ,2,vers la tour ,1]
[deplacer de la tour ,3,vers la tour ,2]
[deplacer de la tour ,1,vers la tour ,3]
[deplacer de la tour ,1,vers la tour ,2]
[deplacer de la tour ,3,vers la tour ,2]
[deplacer de la tour ,1,vers la tour ,3]
[deplacer de la tour ,2,vers la tour ,1]
[deplacer de la tour ,2,vers la tour ,3]
[deplacer de la tour ,1,vers la tour ,3]
[deplacer de la tour ,2,vers la tour ,1]
[deplacer de la tour ,3,vers la tour ,2]
[deplacer de la tour ,3,vers la tour ,1]
[deplacer de la tour ,2,vers la tour ,1]
[deplacer de la tour ,2,vers la tour ,3]
[deplacer de la tour ,1,vers la tour ,3]
[deplacer de la tour ,1,vers la tour ,2]
[deplacer de la tour ,3,vers la tour ,2]
[deplacer de la tour ,1,vers la tour ,3]
[deplacer de la tour ,2,vers la tour ,1]
[deplacer de la tour ,2,vers la tour ,3]
[deplacer de la tour ,1,vers la tour ,3]
*/
