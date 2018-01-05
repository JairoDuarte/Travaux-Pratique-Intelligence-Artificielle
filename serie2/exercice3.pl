
:- op(500, fx, ~).
:- op(700, xfx, <==>).
:- op(600, xfx, v).
:- op(300, xfx, &).

~ (A & B) <==> ~A v ~B.

~ (A & B) <==> (A v B).
~ (A & B).
~ (A v B).
A <==> B.

:- op(500, xfx, aime). 
:- op(400, xfy, et). 
:- op(300, fx, la). 
:- op(300, fx, le). 
:- op(300, fx, les).

salim aime les voyages et la lecture.