

entre(N1,N2,X) :-
    integer(N1),
    integer(N2),
    integer(X),
    N1 < X,
    N2 > X, !. 

entre(N1,N2,X) :-
    integer(N1),
    integer(N2),
    integer(X),
    N2 < X,
    N1 > X,!.

compris(N1,N2) :- 
    N1> N2,
    N_ is N2 +1;
    entre(N1,N2,N_),
    write(N_),
    compris(N1,N_),!.

compris(N1,N2) :- 
    N1 < N2,
    N_ is N1 +1;
    entre(N1,N2,N_),
    write(N_),
    compris(N1,N_),!.
