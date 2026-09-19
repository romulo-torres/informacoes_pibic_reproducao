% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((in(X, newhaven) => ~(high(X))))).
fof(p2, axiom, ! [X] : ((yalehousing(X) => in(X, newhaven)))).
fof(p3, axiom, ! [X] : ((in(X, manhattan) => high(X)))).
fof(p4, axiom, ! [X] : ((bloomberg(X) => in(X, manhattan)))).
fof(p5, axiom, ! [X] : ((bloomberglogo(X) => bloomberg(X)))).
fof(p6, axiom, yalehousing(tower_a)).
fof(p7, axiom, bloomberglogo(tower_b)).
fof(extra1, axiom, (~(in(tower_b, manhattan)))).
