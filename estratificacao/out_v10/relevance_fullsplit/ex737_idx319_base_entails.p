% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((dog(X) => sleep(X)))).
fof(p2, axiom, ? [X] : (? [Y] : (((((((fourlegged(X) & animal(X)) & dog(X)) & fourlegged(Y)) & animal(Y)) & dog(Y)) & ~((X = Y)))))).
fof(extra1, axiom, ~(? [X] : (? [Y] : (((((((fourlegged(X) & animal(X)) & sleeps(X)) & fourlegged(Y)) & animal(Y)) & sleeps(Y)) & ~((X = Y))))))).
