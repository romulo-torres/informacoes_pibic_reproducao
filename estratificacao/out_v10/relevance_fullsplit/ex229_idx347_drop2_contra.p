% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (bornin(robertzimmer, germany) & philosopher(robertzimmer))).
fof(p2, axiom, bornin(robertzimmer, yr1953)).
fof(p3, axiom, ! [X] : ((essayist(X) => writer(X)))).
fof(extra1, axiom, (~(writer(robertzimmer)))).
