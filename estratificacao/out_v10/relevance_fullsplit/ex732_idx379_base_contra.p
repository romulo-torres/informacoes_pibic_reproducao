% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((tissue(X) => soft(X)))).
fof(p2, axiom, ? [X] : (? [Y] : (((((paper(X) & paper(X)) & tissue(X)) & tissue(Y)) & ~((X = Y)))))).
fof(extra1, axiom, (? [X] : (? [Y] : (((((paper(X) & paper(Y)) & hard(X)) & hard(Y)) & ~((X = Y))))))).
