
herbivore(antilope).
feroce(lion).

carnivore(X):-
    feroce(X).

manger(X,Y):-
    carnivore(X),herbivore(Y).

manger(X, viande) :-
    carnivore(X).

manger(X, herbe):-
    herbivore(X).

boire(X, eau):-
    animal(X).


animal(X) :-
    carnivore(X);
    herbivore(X).

consome(X, Y) :-
    manger(X, Y);
    boire(X, Y).


/* les faits

herbivore(antilope).
carnivore(lion).
feroce(lion).
mange(carnivore, viande).
mange(herbivore,herbe).
boivent(carnivore, eau).
boivent(herbivore, eau).




carnivore(X):-
    feroce(X).

mange_quoi(X, Y):-
    carnivore(X),mange(carnivore,Y);
    herbivore(X),mange(herbivore,Y).

boivent_quoi(X, Y):-
    carnivore(X),boivent(carnivore,Y);
    herbivore(X),boivent(herbivore,Y).
*/
