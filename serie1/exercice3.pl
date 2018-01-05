/* Exercice 3*/

/* les faits */
presse(x).


/* les règles */

% R1

paye(X, impots) :-
    serieux(X).


%R2

paye(X, amendes) :-
    presse(X).

%R3
serieux(X) :-
    paye(X,amendes).


%R4

libre(X) :-
    paye(X,impots).

