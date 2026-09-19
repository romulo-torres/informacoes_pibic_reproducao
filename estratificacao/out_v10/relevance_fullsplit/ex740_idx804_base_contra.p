% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : (? [Y] : ((((fear(X) & anxiety(Y)) & leadto(X, Y)) & ~((X = Y)))))).
fof(p2, axiom, ? [X] : (? [Y] : (((anxiety(X) & terror(Y)) & leadto(X, Y))))).
fof(extra1, axiom, (! [X] : (! [Y] : ((fear(X) => ~((terror(Y) & leadto(X, Y)))))))).
