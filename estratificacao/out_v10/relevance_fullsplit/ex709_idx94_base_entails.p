% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((senaterepublican(X) => electedofficial(X)))).
fof(p2, axiom, ? [X] : (? [Y] : (((((electedofficial(X) & electedofficial(Y)) & ~(conservative(X))) & ~(conservative(Y))) & ~((X = Y)))))).
fof(extra1, axiom, ~(? [X] : (? [Y] : (((((conservative(X) & conservative(Y)) & ~(senaterepublican(X))) & ~(senaterepublican(Y))) & ~((X = Y))))))).
