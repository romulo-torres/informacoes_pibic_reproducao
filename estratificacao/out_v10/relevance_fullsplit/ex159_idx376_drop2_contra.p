% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((roundel(X) => (rounded(X) & artilleryfortification(X))))).
fof(p2, axiom, ! [X] : ((artilleryfortification(X) => deploycannons(X)))).
fof(p3, axiom, ! [X] : (! [Y] : (((roundel(X) & artilleryfortification(Y)) => older(X, Y))))).
fof(p4, axiom, ! [X] : ((batterytower(X) => artilleryfortification(X)))).
fof(extra1, axiom, (! [X] : (! [Y] : (((roundel(X) & batterytower(Y)) => older(X, Y)))))).
