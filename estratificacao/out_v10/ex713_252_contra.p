% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((protein(X) => organiccompound(X)))).
fof(p2, axiom, ! [X] : ((enzyme(X) => organiccompound(X)))).
fof(extra1, axiom, (! [X] : ((enzyme(X) => protein(X))))).
