% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (((commonutilities(water) & commonutilities(electricity)) & commonutilities(gas)) & commonutilities(heating))).
fof(p2, axiom, ? [X] : (((apartment(X) & cover(X, water)) & cover(X, electricity)))).
fof(p3, axiom, ! [X] : ((((((apartment(X) & livein(susan, X)) & cover(X, water)) & cover(X, electricity)) & cover(X, gas)) & cover(X, heating)))).
fof(p4, axiom, ! [X] : ((((((apartment(X) & livein(ava, X)) & ~(cover(X, water))) & ~(cover(X, electricity))) & ~(cover(X, gas))) & ~(cover(X, heating))))).
fof(extra1, axiom, ~(! [X] : (((apartment(X) & livein(susan, X)) & cover(X, water))))).
