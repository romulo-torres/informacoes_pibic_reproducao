% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((worldmajorlargepassengeraircraftmanufacturer(X) => ((X = boeing) <~> (X = airbus))))).
fof(p2, axiom, ! [X] : ((americanairlinesaircraft(X) => worldmajorlargepassengeraircraftmanufacturer(X)))).
fof(p3, axiom, moreinrevenue(airbus, boeing)).
fof(extra1, axiom, ~(? [X] : ((commercialaircraft(X) & (X = spacex))))).
