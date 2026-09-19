% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : (? [Y] : (((((((american(X) & musicsupervisor(X)) & radiopersonality(X)) & ~((X = Y))) & american(Y)) & musicsupervisor(Y)) & radiopersonality(Y))))).
fof(p2, axiom, ! [X] : (! [Y] : (((hostshowon(X, Y) & publicradiostation(X)) => radiopersonality(X))))).
fof(p3, axiom, radiopersonality(joerogan)).
fof(p4, axiom, ? [X] : ((hostshowon(jasonkramer, X) & publicradiostation(X)))).
fof(extra1, axiom, (musicsupervisor(jasonkramer))).
