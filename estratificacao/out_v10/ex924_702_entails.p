% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((disposable(X) => designedtobeonlyusedonce(X)))).
fof(p2, axiom, ? [X] : (ecofriendly(X))).
fof(p3, axiom, ! [X] : ((usedin(X, tomshouse) => (disposable(X) <~> reusable(X))))).
fof(p4, axiom, ! [X] : ((madefrom(X, metal) => ~(madefrom(X, plastic))))).
fof(p5, axiom, ! [X] : ((reusable(X) => madefrom(X, metal)))).
fof(p6, axiom, ~((madefrom(chopsticksusedintomshouse, metal) <~> madefrom(chopsticksusedintomshouse, plastic)))).
fof(extra1, axiom, ~(ecofriendly(chopsticks))).
