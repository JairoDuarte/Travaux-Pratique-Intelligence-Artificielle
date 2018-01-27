/*----------------------------------------------------------------------
	Programme : best_fs.pl
	
	Algorithme de recherche inform�e : Meilleur d'abord et A*	
	
	Proc�dure de r�solution :
		resoudre(+Feval, +Etat_initial, -Chemin_Sol, -Actions, -Cout)	
	
		- Feval : proc�dure d'arit� 3 qui permet de calculer la fonction d'�valuation
					doit etre de la forme :
							Feval(+Etat, +G, -F) 
					o� G est le cout necessaire pour atteindre Etat � partir de l'�tat initial
					la valeur F calcul�e est celle de la fonction d'�valuation de Etat.
		- Etat_initial est l'�tat initial
		- Chemin_Sol, Actions et Cout sont respectivement le chemin solution, la liste des actions
			qui r�alisent ce chemin et son cout. Ces trois donn�es sont calcul�es par la proc�dure 'resoudre'
	
	Proc�dures � d�finir correspondantes au probl�me pour pouvoir utiliser la proc�dure 'resoudre'
		- test_but(Etat)
			est vrai si Etat est l'�tat final (�tat but)

		- succ(Etat1, Etat2, Action, Cout)
			relation successeur : Etat2 est un successeur de Etat1
			Cout = cout(E1, E2)
			Action = action qui meme de E1 � E2		

	Formulation :	
		On represente un noeud N par :
					N = noeud(Etat, G, F, Chemin, Actions)
		o�
			- Etat est l'�tat correspondant au noeud 
			- Chemin est le chemin qui m�ne de l'�tat initial � cet �tat dans l'ordre inverse.
			- G = g(N) cout entre l'�tat initial et Etat : 
					g(N) = cout(Chemin) + cout(Pere(Etat), Etat)
			- F = f(N) valeur de la fonction d'�valuation de N
			- Actions : liste des actions qui m�nent de l'�tat initial � cet �tat
	
		Noeud initial : noeud(Etat_initial,0, F0, [], [])
			F0 = f(Etat_initial) (sans interet)

	Proc�dures utilis�es :
		
		- chercher(+Feval, +Candidats, -Chemin_Sol, -Actions, -Cout) :	cherche la solution parmi 
				la liste des candidats en utilisant la fonction d'�valuation d�finie par Feval
			Candidats : liste des noeuds candidats
			Chemin_sol : chemin recherch� dans l'ordre inverse
			Actions : est la liste des actions correspondantes � Chemin_Sol
			Cout : est le cout du chemin.
		
		- noeud_succ(Feval, +N1, -N2) : calcule N2 un noeud successeur de N1.
			l'�tat de N2 ne se trouve pas dans le chemin de N1 (evite les cycles).
			
		- developper(Feval, +N, -Lst_Succ) : Lst_Succ est la liste des successeurs de N
			
		- inserer_tout(+L, +Cdts1, -Cdts2) : 
			insere les noeuds de la liste L dans Cdts1 pour obtenir Cdts2
			suivant l'ordre croissant de F (valeur d'�valuation)
			
		- inserer(+N, +Cdts1, -Cdts2)
			insere dans l'ordre croissant de F
			le noeud N dans Cdts1 pour obtenir Cdts2
			
		- meilleur(+N1,+N2)
			vrai si f(N1) < f(N2)
	
		- etat(+N,-E) :	donne l'etat E correspondant au noeud N
		
		- suppr_si(+X, +L1, -L2) : supprime X de L1 pour trouver L2
			Contrairement � la proc�dure 'suppr', cette proc�dure n'�choue pas si X n'est pas dans L1
			Elle est d�finie dans le fichier listes.pl
			
 ---------------------------------------------------------------------*/
 
% -------------------------- Proc�dure de r�solution	
resoudre(Feval, Etat_initial, Chemin_Sol, Solution, Cout) :-
	Fct_Eval =.. [Feval, Etat_initial, 0, F0],
	call(Fct_Eval),							
	chercher(Feval, [noeud(Etat_initial, 0, F0, [], [])], Chemin_Sol1,  Solution1, Cout),!,
	reverse(Chemin_Sol1, Chemin_Sol),
	reverse(Solution1, Solution).	

% -------------------------- Recherche
% si l'�tat final est atteinte
chercher(_Feval, [noeud(Etat, G, _F, Chemin, Actions)|_], [Etat|Chemin], Actions, G) :-
	test_but(Etat).

% sinon
chercher(Feval, [Noeud|Reste_Candidats], Chemin_Sol, Solution, Cout) :-
	developper(Feval, Noeud, Lst_Succ),
	inserer_tout(Lst_Succ, Reste_Candidats, Nouveaux_Candidats),
	chercher(Feval, Nouveaux_Candidats, Chemin_Sol, Solution, Cout).

% -------------------------- Developpement
noeud_succ(Feval, noeud(E, G, _F, Ch, Actions), noeud(E1, G1, F1, [E|Ch], [A|Actions])) :-
	succ(E, E1, A, C),
	G1 is G + C,
	Fct_Eval =.. [Feval, E1, G1, F1],
	call(Fct_Eval),	
	not( membre(E1, Ch) ).
	
developper(Feval, N, Lst_Succ) :-
	findall( N1 , noeud_succ(Feval, N, N1), Lst_Succ). 

% -------------------------- Incorporation des candidats
inserer_tout([], Candidats, Candidats).

inserer_tout([N|Reste], Candidats1, Candidats3) :-
	inserer(N, Candidats1, Candidats2),
	inserer_tout(Reste, Candidats2, Candidats3).

% inserer(N, Cdts1, Cdts2)
% Cas 1 : Cdts1 = [N1|R1] 
% Cas 1.1 : �tat(N) = �tat(N1) choisir le meilleur
% si N est meilleur que N1 : on remplace N1 par N
inserer( noeud(E,G,F,Ch,A), [noeud(E,_G1,F1,_Ch1,_A1)|R1], [noeud(E,G,F,Ch,A)|R1]) :- 
	F < F1, ! .
% sinon on ignore N
inserer( noeud(E,_G,_F,_Ch,_A), [noeud(E,G1,F1,Ch1,A1)|R1], [noeud(E,G1,F1,Ch1,A1)|R1]) :- ! .

% Cas 1.2 : �tat(N) <> �tat(N1)
% si N est meilleur que N1
inserer(N,[N1|R1],[N,N1|R2]) :- 
	meilleur(N,N1), ! ,
	etat(N, E),
	suppr_si(noeud(E,_G,_F,_Ch,_A), R1, R2).
% sinon
inserer(N,[N1|R1],[N1|R2]) :- 
	inserer(N,R1,R2), !.

% Cas 2 :Cdts = []
inserer(N,[],[N]).

% -------------------------------------------------------------------------------------- 

% le meilleur de deux noeuds
meilleur( noeud(_,_,F1,_,_) , noeud(_,_,F2,_,_) ) :- F1 <  F2.

% �tat d'un noeud
etat(noeud(E,_G,_F,_Ch,_A), E).
