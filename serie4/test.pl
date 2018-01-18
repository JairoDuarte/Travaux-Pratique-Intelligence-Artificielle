
 /*  % s(sommet,list_adjacents,couleurs: une couleur de la liste couleurs affecté au sommet)
  %  couleurs(+G,+LS,-LC) :- setofs(c,s^La^(membre(S,LS), membre(S(S,La,C),G)),LC).

    /* liste de couleurs de tous les sommets */
 %   couleurs(G,LC) :- 


%suppr(s(1,Cc,LA),[s(3,rouge,[1,2]),s(1,rouge,[2,3]),s(2,rouge,[1,3])],Rc). 
%setof(Cc,membre(Cc,[rouge,neutre,neutre,jeune,vert]),L).
*/

operation(X,Y,Z,X+Y) :- Z is X+Y.

sousliste([],[]).
sousliste(R,[_|S]) :- sousliste(R,S). 
sousliste([T|R],[T|S]) :- sousliste(R,S).

insere(T,M,[T|M]).
insere(T,[M|N],[M|Q]):- insere(T,N,Q). 

permutation([],[]).
permutation([T|R],L) :- permutation(R,M), insere(T,M,L).

decompose([A|B],[C|D],E) :- append([A|B],[C|D],E).

construit_chaıne(A,B,Op,C) :- 
    string_to_list(Paropen, "("), 
    string_to_list(Parclose, ")"), string_concat(Paropen, A, Temp1), 
    string_concat(Temp1, Op, Temp2), string_concat(Temp2, B, Temp3), 
    string_concat(Temp3, Parclose, C).

combine([A,SA],[B,SB],[C,SC]) :-
    C is A+B,
    string_to_list(Plus,"+"), construit_chaıne(SA,SB,Plus,SC).
combine([A,SA],[B,SB],[C,SC]) :- A > B,
    C is A-B, string_to_list(Moins,"+"), construit_chaıne(SA,SB,Moins,SC).
combine([A,SA],[B,SB],[C,SC]) :- C is A*B,
    string_to_list(Mult,"*"), construit_chaıne(SA,SB,Mult,SC).
combine([A,SA],[B,SB],[C,SC]) :-
    A mod B =:= 0,
    C is A/B, string_to_list(Div,"/"), construit_chaıne(SA,SB,Div,SC).

valeur([],_) :- !, fail.
valeur([A],VA) :- !, string_to_atom(SA,A), VA=[A,SA].
valeur(L,D) :-
    decompose(X,Y,L), valeur(X,VX), valeur(Y,VY), combine(VX,VY,D).

reussite(C,[A,_]) :- C = A.

main(L,C,D) :- valeur(L,D), reussite(C,D).