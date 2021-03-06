/* Les Simpsons */

% les clauses, faits
/* clauses d�crivant la relation parent  */


parent(abraham,herb).
parent(mona,homer).
parent(abraham,homer).
parent(clancy,marge).
parent(clancy,patty).
parent(clancy,selma).
parent(jackie,marge).
parent(jackie,patty).
parent(jackie,selma).
parent(homer,bart).
parent(homer,lisa).
parent(homer,maggie).
parent(marge,bart).
parent(marge,lisa).
parent(marge,maggie).
parent(selma,ling).

/* faits exercice 2  */
parent(paul,cloe).
parent(paul,marc).
parent(aude,marc).
parent(marc,lisa).
parent(cloe,dana).
parent(marc,dana).
parent(dana,abel).

/* clauses d�crivant la propri�t� masculin */

masculin(abraham).
masculin(herb).
masculin(homer).
masculin(clancy).
masculin(bart).

/* clauses d�crivant la propri�t� feminin */

feminin(mona).
feminin(jackie).
feminin(marge).
feminin(patty).
feminin(selma).
feminin(ling).
feminin(lisa).
feminin(maggie).

/* r�gles  */

% relation p�re

pere( X, Y) :-
    parent(X, Y),
    masculin(X).


pere(X) :-
    parent(X, _),
    masculin(X).

% relation m�re

mere(X, Y) :-
    parent(X ,Y),
    feminin(X).

mere(X) :-
    parent(X, _),
    feminin(X).

% relation fr�re

frere(X, Y) :-
    parent(Z, X),
    parent(Z, Y),
    masculin(X),
    X \= Y.

% relation soeur

soeur(X, Y) :-
    parent(Z, X),
    parent(Z, Y),
    feminin(X),
    X \= Y.

% relation gran-parent

grand_parent(X, Y) :-
    parent(X, Z),
    parent(Z, Y).

grand_parent(X) :-
    parent(X, Y),
    parent(Y, _).

% relation tante

tante(X, Y) :-
    parent(Z, Y),
    soeur(X, Z).

tante(X) :-
    parent(Z, _),
    soeur(X, Z).

% relation oncle

oncle(X ,Y) :-
    parent(Z, Y),
    frere(X, Z).

oncle(X) :-
    parent(Z, _),
    frere(X, Z).

predecesseur(X, Y) :-
    parent(X, Y).

predecesseur(X, Y) :-
    parent(X, Z),
    parent(Z, Y).

predecesseur(X, Y) :-
    parent(X, Y);
    parent(X, Z),
    predecesseur(Z, Y).
