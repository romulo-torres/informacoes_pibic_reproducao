% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : (((apartment(X) & cover(X, water)) & cover(X, electricity)))).
fof(p2, axiom, ! [X] : ((((((apartment(X) & livein(susan, X)) & cover(X, water)) & cover(X, electricity)) & cover(X, gas)) & cover(X, heating)))).
fof(p3, axiom, ! [X] : ((((((apartment(X) & livein(ava, X)) & ~(cover(X, water))) & ~(cover(X, electricity))) & ~(cover(X, gas))) & ~(cover(X, heating))))).
fof(p4, axiom, ! [X] : (((apartment(X) & livein(noah, X)) & ~(cover(X, heating))))).
fof(extra1, axiom, ((~(cover(noah, heating)) & ~(cover(ava, heating))))).
