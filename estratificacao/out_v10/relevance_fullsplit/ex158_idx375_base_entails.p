% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((roundel(X) => (rounded(X) & artilleryfortification(X))))).
fof(p2, axiom, ! [X] : (! [Y] : (((roundel(X) & adjacentwalls(X, Y)) => ~(higher(X, Y)))))).
fof(p3, axiom, ! [X] : ((artilleryfortification(X) => deploycannons(X)))).
fof(p4, axiom, ! [X] : (! [Y] : (((roundel(X) & artilleryfortification(Y)) => older(X, Y))))).
fof(p5, axiom, ! [X] : ((batterytower(X) => artilleryfortification(X)))).
fof(extra1, axiom, ~(! [X] : ((batterytower(X) => deploycannons(X))))).
