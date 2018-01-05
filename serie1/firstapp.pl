% Fats
gerou(kelly,maria). %clause
gerou(cleber,maria).
gerou(cleber,bruna).
gerou(kelly,bruna).
gerou(maria,julia).
gerou(maria,pedro).
gerou(pedro,lucas).

feminino(kelly).
feminino(maria).
feminino(julia).
feminino(bruna).
masculino(cleber).
masculino(lucas).
masculino(pedro).

%regras
filho(Y, X) :-
    gerou(X, Y).
mae(X, Y) :-
    gerou(X,Y),
    feminino(X).
avos(X,Z) :-
    gerou(X , Y),
    gerou(Y, Z).
