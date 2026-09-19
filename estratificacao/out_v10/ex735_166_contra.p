% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((road(X) => ~(dustless(X))))).
fof(p2, axiom, ? [X] : (? [Y] : (((((street(X) & street(Y)) & road(X)) & road(Y)) & ~((X = Y)))))).
fof(extra1, axiom, (? [X] : (? [Y] : (((((street(X) & street(Y)) & dustless(X)) & dustless(Y)) & ~((X = Y))))))).
