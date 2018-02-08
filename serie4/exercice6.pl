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

/* ------------------- Relation successeur ------------- 
 succ(+E1,-E2)
 succ(+E1,-E2,Action)
------------------------------------------------------*/
succ(robot(p(X,Y)),robot(p(X1,Y1))) :-
    voisine(p(X,Y),p(X1,Y1)),mandist(p(X,Y),p(X1,Y1),1),
    valide(p(X1,Y1)),not(mur(p(X1,Y1))).

succ(robot(p(X,Y)),robot(p(X1,Y1)),["deplacer de la case ",X/Y,"vers la case ",X1/Y1]) :-
    voisine(p(X,Y),p(X1,Y1)),mandist(p(X,Y),p(X1,Y1),1),
    valide(p(X1,Y1)),not(mur(p(X1,Y1))).

succ(E1,E2,Action,1) :- succ(E1,E2,Action).

/* voisine(+P1,-P2) P2 est la position voisine de P1   */
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

/* abs(A,B,D) : D = |A-B| (valeur absolue)  */
abs(A,B,D) :-
    D is A - B, 
    D >= 0, !. 
abs(A,B,D) :- 
    D is B - A.


/* ------------------  Heuristique --------------------------------- 
H(X) est la distance entre la position actuel du robot  et la porte.
*/ 
h(robot(P), H) :-
    porte(P1),
    mandist(P,P1,H).



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

%-------------------- Algorithme Best_fs ------------------------
:- consult('best_fs.pl').
%-----------------------------------------------------------------------

/*----------------------------------------------------------------------
	Programme : a_etoile.pl
	Algorithme A*
		
	On represente un noeud N par 
		N = noeud(Etat,G,F,Chemin)
	où 
	- Etat est l'état correspondant au noeud 
	- Chemin est le chemin qui mène de l'état initial à cet état dans l'ordre inverse.
	- G = g(N) cout entre l'état initial et Etat : 
			g(N) = cout(Chemin) + cout(Pere(Etat), Etat)
	- F = f(N) = g(N) + h(N)
	
	Noeud initial : noeud(Etat_initial,0, F0, [])
		F0 = f(Etat_initial) (sans interet)

-----------------------------------------------------------------------
Procédure de résolution :	
	a_etoile(Etat_initial, Solution)
		Solution est le chemin de Etat_initial à l'état final (but)

Procédures utilisées :
	- f(Etat, G, F) 
		calcul de F = f(Etat) (fonction d'évaluation)
	- etat(N,E)
		E est l'etat correspondant du noeud N
	- chercher(Candidats, S)
		Candidats : liste des noeuds candidats
		S : chemin recherché dans l'ordre inverse
		cherche la solution parmi la liste des candidats
	- noeud_succ(N1, N2)
		N2 est un noeud successeur de N1.
		l'état de N2 ne se trouve pas dans le chemin de N1 (evite les
		cycles).
	- developper(N, Lst_Succ)
		Lst_Succ est la liste des successeurs de N
	- inserer_tout(L,Cdts1, Cdts2)
		insere les noeuds de la liste L dans Cdts1 pour obtenir Cdts2
		suivant l'ordre croissant de F (valur d'évaluation)
	- inserer(N,Cdts1, Cdts2)
		insere dans l'ordre croissant de F
		le noeud N dans Cdts1 pour obtenir Cdts2
	- meilleur(N1,N2)
		vrai si f(N1) < f(N2)
	
-----------------------------------------------------------------------
Procédures utilisées correspondantes au problème à résoudre :
	- test_but(Etat)
		est vrai si Etat est l'état final (état but)

	- succ(Etat1, Etat2,Cout)
		relation successeur : Etat2 est un successeur de Etat1
		Cout = cout(E1, E2)
	
	- h(Etat, H) 
		H = h(Etat) fonction heuristique	
 ---------------------------------------------------------------------*/

a_etoile(Etat_initial, Solution) :-
	f(Etat_initial, 0, F),							
	chercher([noeud(Etat_initial,0,F,[])], S),
	reverse(S, Solution).	

% calcul de la fonction d'évaluation
f(Etat, G, F) :-
	h(Etat, H),
	F is G + H.
	
% etat d'un noeud
%etat(noeud(E,_G,_F,_Ch), E).

/* ----------------  Recherche ------------------------------- */
/* si l'état final est atteinte */
/*chercher( [noeud(Etat,_G,_F,Chemin)|_], [Etat|Chemin] ) :-
	write(noeud(Etat,_G,_F,Chemin)),nl,test_but(Etat).

% sinon
chercher([Noeud|Reste_Candidats], Solution) :-
	developper(Noeud, Lst_Succ),
	inserer_tout(Lst_Succ, Reste_Candidats, Nouveaux_Candidats),
	chercher(Nouveaux_Candidats, Solution).

% ----------------  Developpement
noeud_succ(noeud(E,G,_F,Ch), noeud(E1,G1,F1,[E|Ch])) :-
	succ(E, E1,A,C),
	G1 is G + C,
	f(E1, G1, F1),
	not( membre(E1, Ch)).
	
developper(N, Lst_Succ) :-
	bagof( N1 , noeud_succ(N,N1), Lst_Succ). 

% ----------------  Insertion
inserer_tout([], Candidats, Candidats).

inserer_tout([N|Reste], Candidats1, Candidats3) :-
	inserer(N, Candidats1, Candidats2),
	inserer_tout(Reste, Candidats2, Candidats3).

% inserer(N, Cdts1, Cdts2)
% Cas 1 : Cdts1 = [N1|R1] 
% Cas 1.1 : état(N) = état(N1) choisir le meilleur
% si N est meilleur que N1
inserer( noeud(E,G,F,Ch), [noeud(E,_G1,F1,_Ch1)|R1], [noeud(E,G,F,Ch)|R1]) :- 
	F < F1, ! .
% sinon
inserer( noeud(E,_G,_F,_Ch), [noeud(E,G1,F1,Ch1)|R1], [noeud(E,G1,F1,Ch1)|R1]) :- ! .

% Cas 1.2 : état(N) <> état(N1)
% si N est meilleur que N1
inserer(N,[N1|R1],[N,N1|R2]) :- 
	meilleur(N,N1), ! ,
	etat(N, E),
	suppr(noeud(E,_G,_F,_Ch), R1, R2).
% sinon
inserer(N,[N1|R1],[N1|R2]) :- 
	inserer(N,R1,R2), !.

% Cas 2 :Cdts = []
inserer(N,[],[N]).

meilleur( noeud(_,_,F1,_,_) , noeud(_,_,F2,_,_) ) :- F1 <  F2.
*/
solution_a(E0) :-
	dfs_id(E0, S),
	inverser(S, Sol),
	afficher(Sol).

a_etoile :-
	etat_initial(E), resoudre(f, robot(E), Chemin_Sol, Actions, Cout),
	write("Chemin solution: "),nl, afficher(Chemin_Sol), nl,
	write("Coût du chemin = "), write(Cout),nl,
    write("Actions: "),nl,afficher(Actions).
/*

*/



