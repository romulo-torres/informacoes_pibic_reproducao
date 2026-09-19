% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, locatedon(newyorkcity, eastcoast)).
fof(p2, axiom, locatedon(seattle, westcoast)).
fof(p3, axiom, ! [X] : (! [Y] : (! [Z] : (((((travelingfrom(X, Y) & locatedon(Y, eastcoast)) & travelingto(X, Z)) & locatedon(Z, westcoast)) => onlongflight(X)))))).
fof(p4, axiom, ! [X] : ((((inbuisnessclass(X) & travelingto(X, seattle)) & travelingfrom(X, newyorkcity)) => ~(infirstclass(X))))).
fof(p5, axiom, ! [X] : (((onlongflight(X) & ~(infirstclass(X))) => uncomfortable(X)))).
fof(extra1, axiom, (? [X] : (((travelingto(X, seattle) & travelingfrom(X, newyorkcity)) & uncomfortable(X))))).
