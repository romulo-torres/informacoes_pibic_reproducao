% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, american(monhoff)).
fof(p2, axiom, ! [X] : ((artist(X) => (goodat(X, physicalart) | goodat(X, conceptualart))))).
fof(p3, axiom, ! [X] : ((american(X) => americancitizen(X)))).
fof(extra1, axiom, ~(~(? [X] : ((illustrator(X) & americancitizen(X)))))).
