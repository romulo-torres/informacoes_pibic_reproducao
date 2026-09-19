% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (actor(daveeddiggs) & filmproducer(daveeddiggs))).
fof(p2, axiom, ? [X] : (? [Y] : (((actor(X) & playsin(X, Y, hamilton)) & wins(X, bestactoraward))))).
fof(p3, axiom, ? [X] : (((actor(X) & playsin(X, thomasjefferson, hamilton)) & wins(X, bestactoraward)))).
fof(p4, axiom, plays(daveeddiggs, thomasjefferson)).
fof(p5, axiom, ! [X] : (((musical(X) & onbroadway(X)) => ~(film(X))))).
fof(extra1, axiom, ~(film(hamilton))).
