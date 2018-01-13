:- include("../outils.pl").

op_c(X,Y,Z,W) :-
    Z is X*Y,
    W = X*Y.

op_c(X,Y,Z,W) :- 
    Z is X+Y,
    W = X+Y.

op_c(X,Y,Z,W) :- 
    Z is X/Y,
    W = X / Y.

op_c(X,Y,Z,W) :- 
    Z is X-Y,
    W = X - Y.

main([Y],Y).
main([X|Reste],Q) :-
    result([X|Reste],R,K),
    R =:= Q,
    write(K),!. 

result([X,Y],Z,W) :- op_c(X,Y,Z,W).
result([X,Y|Reste],Q,I) :-
    op_c(X,Y,Z,W),
    result([W|Reste],Q,I).
    %K = I.


%calc([Y],)
calc([T],_,T).
calc([X,Y|R], Z, W) :-
    calc([Y|R], Z,K),
    op_c(X,Y,F),
    op_c(F,K,W),
    Z == W.


calc_t([],0).
calc_t([Y],Y).
calc_t([X,Y|R],Z) :-
    op_c(X,Y,Z),
    calc_t([Y|R],Z),
    op_c(Z,RS,RF).