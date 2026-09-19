% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((rabbit(X) => have(X, fur)))).
fof(p2, axiom, ? [X] : ((pet(X) & rabbit(X)))).
fof(extra1, axiom, (? [X] : (? [Y] : ((((pet(X) & pet(Y)) & ~(have(X, fur))) & ~(have(Y, fur))))))).
