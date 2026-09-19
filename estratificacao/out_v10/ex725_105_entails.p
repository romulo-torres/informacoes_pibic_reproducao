% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((bear(X) & in(X, zoo)) => ~(wild(X))))).
fof(p2, axiom, ? [X] : (? [Y] : (((((bear(X) & bear(Y)) & in(X, zoo)) & in(Y, zoo)) & ~((X = Y)))))).
fof(extra1, axiom, ~(? [X] : ((bear(X) & ~(wild(X)))))).
