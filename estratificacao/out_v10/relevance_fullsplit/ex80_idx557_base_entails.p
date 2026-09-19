% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (musicsupervisor(jasonkramer) & american(jasonkramer))).
fof(p2, axiom, ? [X] : (? [Y] : (((((((american(X) & musicsupervisor(X)) & radiopersonality(X)) & ~((X = Y))) & american(Y)) & musicsupervisor(Y)) & radiopersonality(Y))))).
fof(p3, axiom, ! [X] : (! [Y] : (((hostshowon(X, Y) & publicradiostation(X)) => radiopersonality(X))))).
fof(p4, axiom, radiopersonality(joerogan)).
fof(p5, axiom, ? [X] : ((hostshowon(jasonkramer, X) & publicradiostation(X)))).
fof(extra1, axiom, ~(american(joerogan))).
