% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((hungry(X) => uncomfortable(X)))).
fof(p2, axiom, ! [X] : ((uncomfortable(X) => ~(happy(X))))).
fof(extra1, axiom, (! [X] : ((~(hungry(X)) => ~(happy(X)))))).
