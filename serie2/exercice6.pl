

divise(A, B, Q, R) :-
    Q is A // B,
    R is A mod B.

/*
    si a=0:  PGCD(0,b) => b
    si b=0:  PGCD(a,0) => a
    si b > 0 ET a > 0: PGCD(a,b) => AUX = a, a = b, b= AUX mod b, pgcd = PGCD(a,b) 
    *assigner à N1 la valeur de N2 et à N2 la valeur du reste de la division de N1 par N2; 
    *recommencer jusqu'à ce que le reste de la division soit nul. 

*/
pgcd(A, 0, A):- !.
pgcd(0, B, B): !.
pgcd(A, B, PGCD) :-
    N1 = B, N2 is A mod B,
    pgcd(N1,N2, PGCD).


