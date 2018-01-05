/* bio(enfant, sexe, annee_naissance, annee_mort, pere, mere)  */

bio(louis13, h, 1601, 1643, henri4, marie_medicis).
bio(elisabeth_France, f, 1603, 1644, henri4, marie_medicis).
bio(marie_therese_Autriche, f, 1638, 1683, philippe4, elisabeth_france).
bio(louis14, h, 1638, 1715, louis13, anne_autriche).
bio(grand_dauphin, h, 1661, 1711, louis14, marie_therese_autriche).
bio(louis_bourbon, h, 1682, 1712, grand_dauphin, marie_anne_baviere).
bio(philippe5, h, 1683, 1746, grand_dauphin, marie_anne_baviere).
bio(louis15, h, 1710, 1774, louis_bourbon, marie_adelaide_savoie).
bio(louis_dauphin, h, 1729, 1765, louis15, marie_leczcynska).
bio(louis16, h, 1754, 1793, louis_dauphin, marie_josephe_saxe).
bio(louis18, h, 1755, 1824, louis_dauphin, marie_josephe_saxe).
bio(charles10, h, 1757, 1836, louis_dauphin, marie_josephe_saxe).
bio(clotilde, f, 1759, 1802, louis_dauphin, marie_josephe_saxe).
bio(louis17, h, 1785, 1795, louis16, marie_antoinette).
bio(philippe1, h, 1640, 1701, louis13, anne_autriche).
bio(philippe2, h, 1674, 1723, philippe1, charlotte_baviere).
bio(louis_orleans, h, 1703, 1752, philippe, francoise_marie_bourbon).
bio(louis_philippe, h, 1725, 1785, louis_orleans, augusta_marie_bade).
bio(philippe_egalite, h, 1747, 1793, louis_philippe, louise_henriette_bourbon_conti).
bio(louis_philippe1,h,1773,1850,philippe_egalite,louise_marie_adelaide_bourbon_penthievre).

% X est un enfant de Y.

enfant(X, Y) :-
    bio(X,_,_,_,Y,_);
    bio(X,_,_,_,_,Y).

%X est un petit enfant de Y.

ptenfant(X, Y) :-
    bio(Z,_,_,_,Y,_),
    enfant(X, Z);
    bio(Z,_,_,_,_,Y),
    enfant(X, Z).

% X est un descendant de Y.
/*
descendant(X, Y):-
    enfant(X, Y).
*/

descendant(X, Y):-
    enfant(X, Y);
    ptenfant(X, Y);
    bio(Z,_,_,_,Y,_),
    descendant(X, Z);
    bio(Z,_,_,_,_,Y),
    descendant(X, Z).

naissance(X, Y, Z):-
    bio(X,_,AND,_,_,_),
    AND >= Y, AND =< Z.

pas_ne(X, Y, Z):-
    bio(X,_,AND,_,_,_),
    AND < Y; AND > Z.
