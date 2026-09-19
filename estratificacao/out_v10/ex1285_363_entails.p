% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((plant(X) => ~(cuteanimal(X))))).
fof(p2, axiom, ! [X] : ((flower(X) => plant(X)))).
fof(p3, axiom, ! [X] : ((kitten(X) => cuteanimal(X)))).
fof(p4, axiom, ! [X] : ((grownin(X, garden) => flower(X)))).
fof(p5, axiom, (kitten(piper) | cuteanimal(piper))).
fof(extra1, axiom, ~(kitten(piper))).
