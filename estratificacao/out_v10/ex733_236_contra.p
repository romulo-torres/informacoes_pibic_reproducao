% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((iphone(X) => electronic(X)))).
fof(p2, axiom, ? [X] : (? [Y] : (((((phone(X) & phone(Y)) & iphone(X)) & iphone(Y)) & ~((X = Y)))))).
fof(extra1, axiom, (! [X] : ((phone(X) => ~(electronic(X)))))).
