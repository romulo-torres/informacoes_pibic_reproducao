% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : (? [Y] : ((fish(X) => sting(X, Y))))).
fof(p2, axiom, fish(stonefish)).
fof(p3, axiom, ! [X] : (((sting(stonefish, X) & ~(treated(X))) => causedeathto(stonefish, X)))).
fof(p4, axiom, ! [X] : (((sting(stonefish, X) & (applyheatto(X) | useantivenomon(X))) => treated(X)))).
fof(extra1, axiom, (? [X] : (? [Y] : ((((fish(X) & sting(X, Y)) & ~(treated(Y))) => causedeathto(X, Y)))))).
