/*

fichier : famille_1.pl

*/

/* Clauses d�crivant la relation 'parent' */
% parent(X,Y) : X est un parent de Y
parent(paul,cloe).
parent(paul,marc).
parent(aude,marc).
parent(marc,lisa).
parent(marc,dana).
parent(dana,abel).

/* Clauses d�crivant la propri�t� feminin */
feminin(aude).
feminin(cloe).
feminin(lisa).
feminin(dana).

/* Clauses d�crivant la propri�t� masculin */
masculin(paul).
masculin(marc).
masculin(abel).

/* R�gles */
pere(X, Y) :-
    parent(X,Y),
    masculin(X).
