% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((highincome(X) => ~(meanstodestination(X, bus))))).
fof(p2, axiom, ! [X] : ((meanstodestination(X, bus) <~> meanstodestination(X, drive)))).
fof(p3, axiom, ! [X] : ((havecar(X) => meanstodestination(X, drive)))).
fof(p4, axiom, ! [X] : ((student(X) => ~(meanstodestination(X, drive))))).
fof(p5, axiom, (havecar(james) | workat(james, meta))).
fof(extra1, axiom, ~(student(james))).
