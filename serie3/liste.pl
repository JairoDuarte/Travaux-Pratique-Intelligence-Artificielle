/*
	fichier : liste.pl
	Opérations sur les listes
	
NB. 
Pour l'affichage complet des listes ajouter la ligne suivante :
	:- set_prolog_flag(toplevel_print_options,[quoted(true), portray(true)]).
au fichier swipl.ini

Pour que les chaines de caracteres soient considérées comme des listes
	:- set_prolog_flag(double_quotes, codes).

*/

% est_liste(+L) : vrai si L est une liste
est_liste([]).
est_liste([_|R]) :- est_liste(R).

% longueur(+L, -N) : longueur de L si L est une liste, échoue sinon
longueur([],0).
longueur([_|R], N) :-
	longueur(R, N1),
	N is N1+1.

% membre(X,L) est vrai si X est membre de la liste L
membre(X,[X|_]).		
membre(X,[_|Reste]) :-
	membre(X,Reste).		

% conc(L1,L2,L) est vrai si L est la concaténation de L1 et L2
conc([], L, L).
conc([X|R1], L2, [X|R]) :-
	conc(R1,L2,R).

% suppr(X,L1,L2) : L2 est L1 privé de X
suppr(X,[X|R],R).
suppr(X,[Y|R],[Y|R1]):-
	suppr(X,R,R1).

%insert(X, L, L1).
insert(X, L, L1) :- suppr(X, L1, L).

