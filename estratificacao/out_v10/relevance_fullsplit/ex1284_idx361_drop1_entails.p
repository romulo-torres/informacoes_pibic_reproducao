% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((flower(X) => plant(X)))).
fof(p2, axiom, ! [X] : ((kitten(X) => cuteanimal(X)))).
fof(p3, axiom, ! [X] : ((grownin(X, garden) => flower(X)))).
fof(p4, axiom, (kitten(piper) | cuteanimal(piper))).
fof(extra1, axiom, ~(~(grownin(piper, garden)))).
