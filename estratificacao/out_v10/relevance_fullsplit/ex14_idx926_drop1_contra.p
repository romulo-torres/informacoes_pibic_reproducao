% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, precede(longueau, boves)).
fof(p2, axiom, precede(boves, dommartin)).
fof(p3, axiom, in(france, europe)).
fof(p4, axiom, situatedon(dommartin, pairslille)).
fof(p5, axiom, ! [X] : (! [Y] : (! [Z] : (((situatedon(X, Z) & (precede(X, Y) | precede(Y, X))) => situatedon(Y, Z)))))).
fof(p6, axiom, serve(boves, hautsdefrance)).
fof(p7, axiom, ! [X] : (! [Y] : (! [Z] : (((in(X, Y) & in(Y, Z)) => in(X, Z)))))).
fof(p8, axiom, ! [X] : (! [Y] : (! [Z] : (((precede(X, Y) & precede(Y, Z)) => precede(X, Z)))))).
fof(extra1, axiom, (situatedon(longueau, pairslille))).
