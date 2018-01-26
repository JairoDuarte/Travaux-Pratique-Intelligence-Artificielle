:- include("../outils.pl").
:- include("../serie3/liste.pl").

/* --------------------- Les Faits --------- */
salle(8,8).
porte(p(5,8)).
mur(p(8,3)).
mur(p(7,3)).
mur(p(6,3)).
mur(p(5,3)).
mur(p(6,6)).
mur(p(5,6)).
mur(p(4,6)).
mur(p(3,6)).
mur(p(2,6)).

/* --------------------- Exemples d'états initial --------- */
% Eo = 
etat_initial(robot(p(8,1))). 
/* ------------------ Test de but ------------------- */

test_but(robot(P)) :-
    porte(P).

/* ------------------- Relation successeur ------------- */
% succ(+E1,-E2)
/*------------------------------------------------------*/
succ(robot(p(X,Y)),robot(p(X1,Y1))) :-
    voisine(p(X,Y),p(X1,Y1)),mandist(p(X,Y),p(X1,Y1),1),
    valide(p(X1,Y1)),not(mur(p(X1,Y1))).

succ(E1,E2,["deplacer de la tour ",T1,"vers la tour ",T2]) :-
    suppr(tour(T1,L1),E1,R1),
    suppr(tour(T2,L2),R1,R3),
    T1 \= T2,
    deplacer(L1,L2,NL1,NL2),tour_valide(NL2),
    setof(tour(K,Z),membre(tour(K,Z),[tour(T1,NL1),tour(T2,NL2)|R3]),E2).
    %conc([tour(T2,NL2)],R3,Nt),conc([tour(T1,NL1)],Nt,E2).

/*voisine(+P1,-P2) P2 est la position voisine de P1   */
voisine(p(X,Y),p(X1,Y)) :- X1 is X + 1.
voisine(p(X,Y),p(X1,Y)) :- X1 is X - 1, X1 > 0.
voisine(p(X,Y),p(X,Y1)) :- Y1 is Y + 1.
voisine(p(X,Y),p(X,Y1)) :- Y1 is Y - 1, Y1 > 0.

/* valide(+P) True si la position P appartient à la salle  */
valide(p(X,Y)) :-
    salle(N,M),
    between(1,N,X),
    between(1,M,Y).
/* mandist(+A, +B, +D) : D est la distance de Manhattan entre A et B */
mandist(p(X1,Y1), p(X2,Y2), D) :- 
    abs(X1, X2, Dx), 
    abs(Y1, Y2, Dy), 
    D is Dx + Dy.

% abs(A,B,D) : D = |A-B| (valeur absolue) 
abs(A,B,D) :-
    D is A - B, 
    D >= 0, !. 
abs(A,B,D) :- 
    D is B - A.
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

