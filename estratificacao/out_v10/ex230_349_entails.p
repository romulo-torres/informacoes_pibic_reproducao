% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (bornin(robertzimmer, germany) & philosopher(robertzimmer))).
fof(p2, axiom, essayist(robertzimmer)).
fof(p3, axiom, bornin(robertzimmer, yr1953)).
fof(p4, axiom, ! [X] : ((essayist(X) => writer(X)))).
fof(extra1, axiom, ~(biographer(robertzimmer))).
