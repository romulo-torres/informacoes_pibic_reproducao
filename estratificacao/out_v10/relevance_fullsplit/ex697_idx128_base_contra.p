% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((reptile(X) => ~(have(X, fur))))).
fof(p2, axiom, ! [X] : ((snake(X) => reptile(X)))).
fof(extra1, axiom, (? [X] : ((snake(X) & have(X, fur))))).
