% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ((((cat(garfield) & maincharacterof(garfield, filmgarfield)) & orange(garfield)) & fat(garfield)) & like(garfield, lasagna))).
fof(p2, axiom, ((petof(garfield, jon) & petof(odie, jon)) & sharehomewith(garfield, odie))).
fof(p3, axiom, hate(garfield, odie)).
fof(p4, axiom, ! [X] : (! [Y] : (? [Z] : ((((petof(X, Z) & petof(Y, Z)) & hate(X, Y)) => (childish(X) & possessive(X))))))).
fof(extra1, axiom, (? [X] : (((maincharacterof(X, garfield) & childish(X)) & possessive(X))))).
