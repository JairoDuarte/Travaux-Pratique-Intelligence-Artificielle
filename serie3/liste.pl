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
nieme(1,X,[X|_]).
nieme(N,X,[_|R]):- nieme(N1,X,R),
    N is N1+1. % on fait une affectation si la valeur dans N est égal au resultat de N1+1.



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

%
% dernier(Item, L) : Item est le dernier membre de la liste L
%
dernier(Item,[Item]).
dernier(Item, [_|Q]) :- dernier(Item,Q).


% inverser(+L1,?L2)
inverser([], []).
inverser([X|R], L2) :-
	inverser(R, R1),
	conc(R1, [X], L2).

% suppr_si(X,L1,L2) : suprime X de L1 pour obtenir L2 
% si X n'est pas dans L1 alors L1 = L2
suppr_si(_, [], []).
suppr_si(X,[X|R],R).
suppr_si(X,[Y|R],[Y|R1]):-
	suppr_si(X,R,R1).

%
% afficher les �l�ments d'une liste

afficher([]).

afficher([X|L]) :-
	write(X),nl,
	afficher(L).