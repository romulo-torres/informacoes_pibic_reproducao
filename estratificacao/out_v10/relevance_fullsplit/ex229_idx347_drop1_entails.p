% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, essayist(robertzimmer)).
fof(p2, axiom, bornin(robertzimmer, yr1953)).
fof(p3, axiom, ! [X] : ((essayist(X) => writer(X)))).
fof(extra1, axiom, ~(~(writer(robertzimmer)))).
