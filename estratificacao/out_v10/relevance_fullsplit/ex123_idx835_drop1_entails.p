% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, leadsinger(imaginedragon, dan)).
fof(p2, axiom, songwriter(dan)).
fof(p3, axiom, ! [X] : (! [Y] : ((leadsinger(X, Y) => singer(Y))))).
fof(p4, axiom, ! [X] : ((singer(X) => musician(X)))).
fof(p5, axiom, popularsingle(imaginedragon, demons)).
fof(p6, axiom, ((? [X] : (? [Y] : ((popularsingle(imaginedragon, X) & billboardhot100(X)))) & ~((x = y))) & (popularsingle(imaginedragon, y) & billboardhot100(y)))).
fof(extra1, axiom, ~(? [X] : (? [Y] : (((rockband(X) & leadsinger(X, Y)) & songwriter(Y)))))).
