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