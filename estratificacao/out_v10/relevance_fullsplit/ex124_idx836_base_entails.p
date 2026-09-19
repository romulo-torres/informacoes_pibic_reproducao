% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (american(imaginedragon) & rockband(imaginedragon))).
fof(p2, axiom, leadsinger(imaginedragon, dan)).
fof(p3, axiom, songwriter(dan)).
fof(p4, axiom, ! [X] : (! [Y] : ((leadsinger(X, Y) => singer(Y))))).
fof(p5, axiom, ! [X] : ((singer(X) => musician(X)))).
fof(p6, axiom, popularsingle(imaginedragon, demons)).
fof(p7, axiom, ((? [X] : (? [Y] : ((popularsingle(imaginedragon, X) & billboardhot100(X)))) & ~((x = y))) & (popularsingle(imaginedragon, y) & billboardhot100(y)))).
fof(extra1, axiom, ~(~(musician(dan)))).
