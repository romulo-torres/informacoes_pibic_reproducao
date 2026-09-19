% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : (((teacher(X) & workat(X, pool)) & ~(nice(X))))).
fof(p2, axiom, ! [X] : ((poolmanager(X) => lifeguard(X)))).
fof(p3, axiom, ! [X] : ((lifeguard(X) => workat(X, pool)))).
fof(p4, axiom, ~(workat(mary, pool))).
fof(extra1, axiom, (((nice(mary) & teacher(mary)) & workat(mary, pool)))).
