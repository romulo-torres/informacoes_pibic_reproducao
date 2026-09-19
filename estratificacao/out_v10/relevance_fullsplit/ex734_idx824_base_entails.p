% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((table(X) => round(X)))).
fof(p2, axiom, ? [X] : (? [Y] : (((((furniture(X) & furniture(Y)) & table(X)) & table(Y)) & ~((X = Y)))))).
fof(extra1, axiom, ~(? [X] : (? [Y] : (((((furniture(X) & furniture(Y)) & round(X)) & round(Y)) & ~((X = Y))))))).
