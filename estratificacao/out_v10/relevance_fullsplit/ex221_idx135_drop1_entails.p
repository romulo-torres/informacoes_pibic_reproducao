% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((knownspeciesof(X, ambiortus) => isspecies(X, ambiortusdementjevi)))).
fof(p2, axiom, livein(ambiortusdementjevi, mongolia)).
fof(p3, axiom, discover(yevgenykurochkin, ambiortus)).
fof(extra1, axiom, ~(? [X] : ((discover(yevgenykurochkin, X) & birdgenus(X))))).
