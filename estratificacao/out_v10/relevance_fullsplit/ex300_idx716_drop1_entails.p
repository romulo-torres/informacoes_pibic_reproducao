% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, northwestof(baku, shafaq_asiman)).
fof(p2, axiom, ! [X] : (! [Y] : ((northwestof(X, Y) => southeastof(Y, X))))).
fof(extra1, axiom, ~(! [X] : (((geologicalstructures(X) & offshore(X)) => ~(northwestof(baku, X)))))).
