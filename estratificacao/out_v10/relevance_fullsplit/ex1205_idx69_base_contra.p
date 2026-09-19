% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((workat(X, meta) => highincome(X)))).
fof(p2, axiom, ! [X] : ((highincome(X) => ~(meanstodestination(X, bus))))).
fof(p3, axiom, ! [X] : ((meanstodestination(X, bus) <~> meanstodestination(X, drive)))).
fof(p4, axiom, ! [X] : ((havecar(X) => meanstodestination(X, drive)))).
fof(p5, axiom, ! [X] : ((student(X) => ~(meanstodestination(X, drive))))).
fof(p6, axiom, (havecar(james) | workat(james, meta))).
fof(extra1, axiom, ((meanstodestination(x, drive) | student(james)))).
