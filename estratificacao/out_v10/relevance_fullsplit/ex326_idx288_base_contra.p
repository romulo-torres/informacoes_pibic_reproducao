% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((worldmajorlargepassengeraircraftmanufacturer(X) => ((X = boeing) <~> (X = airbus))))).
fof(p2, axiom, ! [X] : ((americanairlinesaircraft(X) => worldmajorlargepassengeraircraftmanufacturer(X)))).
fof(p3, axiom, moreinrevenue(airbus, boeing)).
fof(extra1, axiom, (! [X] : ((americanairlinesplane(X) => ((X = boeing) <~> (X = airbus)))))).
