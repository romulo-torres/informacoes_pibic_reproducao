% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((easy(X) => ? [Y] : ((lessthan(Y, percent20) & acrate(X, Y)))))).
fof(p2, axiom, ! [X] : ((recommended(X) => easy(X)))).
fof(p3, axiom, ! [X] : ((easy(X) <~> hard(X)))).
fof(p4, axiom, (! [X] : (starred(X)) => hard(x))).
fof(p5, axiom, recommended(twosum)).
fof(p6, axiom, starred(foursum)).
fof(extra1, axiom, (easy(twosum))).
