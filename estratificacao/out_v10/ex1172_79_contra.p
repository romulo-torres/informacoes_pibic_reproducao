% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : (? [Y] : (((((((studentintheclass(X) & goodat(X, math)) & goodat(X, chemistry)) & ~((X = Y))) & studentintheclass(Y)) & goodat(Y, math)) & goodat(Y, chemistry))))).
fof(p2, axiom, ! [X] : (((studentintheclass(X) & goodat(X, chemistry)) => enjoy(X, conductingexperiment)))).
fof(p3, axiom, ! [X] : (((studentintheclass(X) & enjoy(X, conductingexperiment)) => goodat(X, planning)))).
fof(p4, axiom, ! [X] : (((studentintheclass(X) & goodat(X, planning)) => ~(failed(X, theclass))))).
fof(p5, axiom, (studentintheclass(james) & ~((goodat(james, chemistry) <~> failed(james, theclass))))).
fof(extra1, axiom, (((goodat(james, chemistry) | failed(james, theclass)) => (goodat(james, planning) <~> goodat(james, math))))).
