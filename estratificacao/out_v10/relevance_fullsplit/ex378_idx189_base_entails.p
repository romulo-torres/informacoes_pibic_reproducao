% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, locatedin(newyorkcity, unitedstatesofamerica)).
fof(p2, axiom, locatedin(usa, northamerica)).
fof(p3, axiom, locatedin(northamerica, westernhemisphere)).
fof(p4, axiom, highlydeveloped(newyorkcity)).
fof(p5, axiom, ! [X] : (! [Y] : (! [Z] : (((locatedin(X, Y) & locatedin(Y, Z)) => locatedin(X, Z)))))).
fof(extra1, axiom, ~(locatedin(newyorkcity, newyork))).
