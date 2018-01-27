/*----------------------------------------------------------------------
	Programme : best_fs.pl
	
	Algorithme de recherche informée : Meilleur d'abord et A*	
	
	Procédure de résolution :
		resoudre(+Feval, +Etat_initial, -Chemin_Sol, -Actions, -Cout)	
	
		- Feval : procédure d'arité 3 qui permet de calculer la fonction d'évaluation
					doit etre de la forme :
							Feval(+Etat, +G, -F) 
					où G est le cout necessaire pour atteindre Etat à partir de l'état initial
					la valeur F calculée est celle de la fonction d'évaluation de Etat.
		- Etat_initial est l'état initial
		- Chemin_Sol, Actions et Cout sont respectivement le chemin solution, la liste des actions
			qui réalisent ce chemin et son cout. Ces trois données sont calculées par la procédure 'resoudre'
	
	Procédures à définir correspondantes au problème pour pouvoir utiliser la procédure 'resoudre'
		- test_but(Etat)
			est vrai si Etat est l'état final (état but)

		- succ(Etat1, Etat2, Action, Cout)
			relation successeur : Etat2 est un successeur de Etat1
			Cout = cout(E1, E2)
			Action = action qui meme de E1 à E2		

	Formulation :	
		On represente un noeud N par :
					N = noeud(Etat, G, F, Chemin, Actions)
		où
			- Etat est l'état correspondant au noeud 
			- Chemin est le chemin qui mène de l'état initial à  cet état dans l'ordre inverse.
			- G = g(N) cout entre l'état initial et Etat : 
					g(N) = cout(Chemin) + cout(Pere(Etat), Etat)
			- F = f(N) valeur de la fonction d'évaluation de N
			- Actions : liste des actions qui mènent de l'état initial à  cet état
	
		Noeud initial : noeud(Etat_initial,0, F0, [], [])
			F0 = f(Etat_initial) (sans interet)

	Procédures utilisées :
		
		- chercher(+Feval, +Candidats, -Chemin_Sol, -Actions, -Cout) :	cherche la solution parmi 
				la liste des candidats en utilisant la fonction d'évaluation définie par Feval
			Candidats : liste des noeuds candidats
			Chemin_sol : chemin recherché dans l'ordre inverse
			Actions : est la liste des actions correspondantes à Chemin_Sol
			Cout : est le cout du chemin.
		
		- noeud_succ(Feval, +N1, -N2) : calcule N2 un noeud successeur de N1.
			l'état de N2 ne se trouve pas dans le chemin de N1 (evite les cycles).
			
		- developper(Feval, +N, -Lst_Succ) : Lst_Succ est la liste des successeurs de N
			
		- inserer_tout(+L, +Cdts1, -Cdts2) : 
			insere les noeuds de la liste L dans Cdts1 pour obtenir Cdts2
			suivant l'ordre croissant de F (valeur d'évaluation)
			
		- inserer(+N, +Cdts1, -Cdts2)
			insere dans l'ordre croissant de F
			le noeud N dans Cdts1 pour obtenir Cdts2
			
		- meilleur(+N1,+N2)
			vrai si f(N1) < f(N2)
	
		- etat(+N,-E) :	donne l'etat E correspondant au noeud N
		
		- suppr_si(+X, +L1, -L2) : supprime X de L1 pour trouver L2
			Contrairement à la procédure 'suppr', cette procédure n'échoue pas si X n'est pas dans L1
			Elle est définie dans le fichier listes.pl
			
 ---------------------------------------------------------------------*/
 
% -------------------------- Procédure de résolution	
resoudre(Feval, Etat_initial, Chemin_Sol, Solution, Cout) :-
	Fct_Eval =.. [Feval, Etat_initial, 0, F0],
	call(Fct_Eval),							
	chercher(Feval, [noeud(Etat_initial, 0, F0, [], [])], Chemin_Sol1,  Solution1, Cout),!,
	reverse(Chemin_Sol1, Chemin_Sol),
	reverse(Solution1, Solution).	

% -------------------------- Recherche
% si l'état final est atteinte
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
% Cas 1.1 : état(N) = état(N1) choisir le meilleur
% si N est meilleur que N1 : on remplace N1 par N
inserer( noeud(E,G,F,Ch,A), [noeud(E,_G1,F1,_Ch1,_A1)|R1], [noeud(E,G,F,Ch,A)|R1]) :- 
	F < F1, ! .
% sinon on ignore N
inserer( noeud(E,_G,_F,_Ch,_A), [noeud(E,G1,F1,Ch1,A1)|R1], [noeud(E,G1,F1,Ch1,A1)|R1]) :- ! .

% Cas 1.2 : état(N) <> état(N1)
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

% état d'un noeud
etat(noeud(E,_G,_F,_Ch,_A), E).
