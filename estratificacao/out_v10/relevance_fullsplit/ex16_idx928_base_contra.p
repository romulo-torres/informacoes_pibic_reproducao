% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (railwaystation(boves) & in(boves, france))).
fof(p2, axiom, precede(longueau, boves)).
fof(p3, axiom, precede(boves, dommartin)).
fof(p4, axiom, in(france, europe)).
fof(p5, axiom, situatedon(dommartin, pairslille)).
fof(p6, axiom, ! [X] : (! [Y] : (! [Z] : (((situatedon(X, Z) & (precede(X, Y) | precede(Y, X))) => situatedon(Y, Z)))))).
fof(p7, axiom, serve(boves, hautsdefrance)).
fof(p8, axiom, ! [X] : (! [Y] : (! [Z] : (((in(X, Y) & in(Y, Z)) => in(X, Z)))))).
fof(p9, axiom, ! [X] : (! [Y] : (! [Z] : (((precede(X, Y) & precede(Y, Z)) => precede(X, Z)))))).
fof(extra1, axiom, (serve(longueau, hautsdefrance))).
