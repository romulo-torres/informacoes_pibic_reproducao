% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((tsleda(X) => ((passenger(X) & vessel(X)) & (cargo(X) & vessel(X)))))).
fof(p2, axiom, ! [X] : ((tsleda(X) => ((norweigian(X) & vessel(X)) & stabilizers(X))))).
fof(p3, axiom, ! [X] : ((stabilizers(X) => ((mechanicaldevice(X) & onlyonships(X)) & powerfulsteamturbine(X))))).
fof(p4, axiom, ! [X] : ((((passenger(X) & vessel(X)) & (cargo(X) & vessel(X))) => (quiet(X) & goodat(X, sea))))).
fof(p5, axiom, ? [X] : (((quiet(X) & goodat(X, sea)) & powerfulsteamturbine(X)))).
fof(p6, axiom, ! [X] : ((ship(X) => vessel(X)))).
fof(extra1, axiom, ~(! [X] : ((tsleda(X) => ~((norweigian(X) & vessel(X))))))).
