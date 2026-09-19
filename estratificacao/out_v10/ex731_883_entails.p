% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((tree(X) => plant(X)))).
fof(p2, axiom, ? [X] : (? [Y] : (((((living(X) & living(Y)) & tree(X)) & tree(Y)) & ~((X = Y)))))).
fof(extra1, axiom, ~(? [X] : (? [Y] : (((((living(X) & living(Y)) & plant(X)) & plant(Y)) & ~((X = Y))))))).
