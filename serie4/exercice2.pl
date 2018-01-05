
op_c(X,Y,Z) :-
    Z is X*Y.

op_c(X,Y,Z) :- 
    Z is X+Y.

op_c(X,Y,Z) :- 
    Z is X/Y.

op_c(X,Y,Z) :- 
    Z is X-Y.
calc([],_,[]).
calc([T],_,T).
calc([X,Y|R], Z, W) :-
    calc([Y|R], Z,K),
    op_c(X,Y,F),
    op_c(F,K,W),
    Z == W.

calc_t([X,Y|R],Z) :-
    op_c(X,Y,Z).
    %calc([Y|R],RF).