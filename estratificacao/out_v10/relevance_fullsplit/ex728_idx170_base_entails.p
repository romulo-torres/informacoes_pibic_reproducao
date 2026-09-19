% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((building(X) => tall(X)))).
fof(p2, axiom, ! [X] : ((tall(X) => height(X)))).
fof(extra1, axiom, ~(! [X] : ((building(X) => magnificent(X))))).
