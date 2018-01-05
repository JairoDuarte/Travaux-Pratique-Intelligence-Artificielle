

n_terme(A, B, C, U0, U1, 0, U0) :- !.

n_terme(A, B, C, U0, U1, 1, U1) :- !.

n_terme(A, B, C, U0, U1, N, R) :- 
    N > 1,
    NX is N-1, NY is N-2,
    n_terme(A, B, C, U0, U1, NX, UX),
    n_terme(A, B, C, U0, U1, NY, UY),
    R is A*UX + B*UY + C,!.

