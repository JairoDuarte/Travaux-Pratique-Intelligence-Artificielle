
/*
nCp = n! % p!(n-p)!

*/

fact(0,1):- !.

fact(N,R):-
    N > 0,
    N1 is N-1,
    fact(N1,R1),
    R is N*R1.

calcul(N,P, R):-
   fact(N,N_),
   fact(P,P_),
   NP is N-P,
   fact(NP, NP_),
   R is N_ / P_ * NP_.