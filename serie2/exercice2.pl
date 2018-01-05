/*
    Exercice 3: 
        L’inspecteur veut connaître les suspects qu’il doit 
        interroger pour un certain nombre de faits
*/

/* faits  */

volee(marie,lundi,hippodrome).
volee(jean,mardi,bar).
sans_argent(max).
jalouse(eve,marie).
present(max,mercredi,bar).
present(eric,mardi,bar).
present(eve,lundi,hippodrome).

/* Règles */

suspect(X) :-
    present(X, Y, Z),
    volee(P, Y, Z),
    jalouse(X, P);
    sans_argent(X).
