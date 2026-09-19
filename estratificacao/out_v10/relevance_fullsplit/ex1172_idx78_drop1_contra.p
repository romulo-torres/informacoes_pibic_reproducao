% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((studentintheclass(X) & goodat(X, chemistry)) => enjoy(X, conductingexperiment)))).
fof(p2, axiom, ! [X] : (((studentintheclass(X) & enjoy(X, conductingexperiment)) => goodat(X, planning)))).
fof(p3, axiom, ! [X] : (((studentintheclass(X) & goodat(X, planning)) => ~(failed(X, theclass))))).
fof(p4, axiom, (studentintheclass(james) & ~((goodat(james, chemistry) <~> failed(james, theclass))))).
fof(extra1, axiom, (((goodat(james, chemistry) | failed(james, theclass)) => (goodat(james, planning) <~> goodat(james, math))))).
