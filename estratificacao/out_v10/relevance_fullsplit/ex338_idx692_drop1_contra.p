% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, woncup(rangers, year2014final)).
fof(p2, axiom, ~((aberdeen = rangers))).
fof(p3, axiom, ! [X] : (! [Y] : (! [Z] : (! [W] : ((((~((X = Y)) & woncup(X, Z)) & woncup(Y, W)) => ~((Z = W)))))))).
fof(extra1, axiom, (? [X] : (woncup(aberdeen, X)))).
