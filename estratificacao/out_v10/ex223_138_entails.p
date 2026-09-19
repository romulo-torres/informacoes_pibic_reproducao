% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (prehistoric(ambiortus) & birdgenus(ambiortus))).
fof(p2, axiom, ! [X] : ((knownspeciesof(X, ambiortus) => isspecies(X, ambiortusdementjevi)))).
fof(p3, axiom, livein(ambiortusdementjevi, mongolia)).
fof(p4, axiom, discover(yevgenykurochkin, ambiortus)).
fof(extra1, axiom, ~(livein(yevgenykurochkin, mongolia))).
