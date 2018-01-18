:- include("../outils.pl").
:- include("../serie3/liste.pl").

/* --------------------- Exemples d'états initial --------- */
% On represente un récipient par r(Quantité_maximal,Quantité_actuel) et un état par une liste de récipients. 
% Eo = [r(3,0),r(5,0),r(8,8)] 

% etat_initial(E):- membre(r(X,Y),E). 
/* ------------------ Test de but ------------------- */

test_but([r(3,0),r(5,4),r(8,4)]).

/* ------------------- Relation successeur ------------- */
% succ(+E1,-E2)
/*------------------------------------------------------*/
succ(E1,E2) :-
    suppr(r(Mx,X),E1,Rs),
    suppr(r(My,Y),Rs,R),
    verser(Mx,X,My,Y,Qx,Qy),
    setof(r(M,K),membre(r(M,K),[r(Mx,Qx),r(My,Qy)|R]),E2).

verser(_,X,My,Y,Qx,Qy) :-
    X =\= 0,
    Z is My -Y, 
    (X > Z,Qy is Y+Z, Qx is X -Z; Z > X,Qy is Y + X,Qx is X-X).

verser(Mx,X,_,Y,Qx,Qy) :-
    Y =\= 0,
    Z is Mx -X, 
    (Y > Z, Qx is X+Z, Qy is Y -Z; Z > Y, Qx is X + Y,Qy is Y-Y).

/*verser(My,Y,Mx,X,Qx,Qy) :-
    X =\= 0,
    Z is My -Y, 
    (X > Z, Qx is Y+Z, Qy is X -Z; Z > X, Qx is Y + X,Qy is X-X).*/

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
:- avec test_but([r(4,0),r(5,4),r(8,4)])

?- solution([r(4,0),r(5,0),r(8,8)],E1).
E1 = [[r(4, 0), r(5, 0), r(8, 8)], [r(4, 4), r(5, 0), r(8, 4)], [r(4, 0), r(5, 4), r(8, 4)
]] ;

:- avec  test_but([r(3,0),r(5,4),r(8,4)])

?- solution([r(3,0),r(5,0),r(8,8)],E1).
ERROR: Out of local stack

la recherche échoue , la solution ne pas trouvable.  

*/
