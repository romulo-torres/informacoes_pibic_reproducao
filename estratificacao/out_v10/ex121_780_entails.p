% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (british(james) & lawyer(james))).
fof(p2, axiom, ((whig(james) & politician(james)) & satinhouseofcommons(james))).
fof(p3, axiom, ! [X] : ((british(X) => european(X)))).
fof(p4, axiom, ! [X] : ((lawyer(X) => familiarwithlaws(X)))).
fof(p5, axiom, ((? [X] : (? [Y] : ((whig(X) & speakfrench(X)))) & ~((x = y))) & (whig(y) & speakfrench(y)))).
fof(extra1, axiom, ~(? [X] : ((european(X) & familiarwithlaws(X))))).
