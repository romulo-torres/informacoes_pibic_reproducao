% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((yalehousing(X) => in(X, newhaven)))).
fof(p2, axiom, ! [X] : ((in(X, manhattan) => high(X)))).
fof(p3, axiom, ! [X] : ((bloomberg(X) => in(X, manhattan)))).
fof(p4, axiom, ! [X] : ((bloomberglogo(X) => bloomberg(X)))).
fof(p5, axiom, yalehousing(tower_a)).
fof(p6, axiom, bloomberglogo(tower_b)).
fof(extra1, axiom, ~(~(in(tower_b, manhattan)))).
