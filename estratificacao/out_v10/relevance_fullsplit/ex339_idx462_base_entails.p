% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ((architect(monhoff) & artist(monhoff)) & illustrator(monhoff))).
fof(p2, axiom, american(monhoff)).
fof(p3, axiom, ! [X] : ((artist(X) => (goodat(X, physicalart) | goodat(X, conceptualart))))).
fof(p4, axiom, ! [X] : ((american(X) => americancitizen(X)))).
fof(extra1, axiom, ~(goodat(monhoff, physicalart))).
