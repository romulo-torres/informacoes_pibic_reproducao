% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((tsleda(X) => ((norweigian(X) & vessel(X)) & stabilizers(X))))).
fof(p2, axiom, ! [X] : ((stabilizers(X) => ((mechanicaldevice(X) & onlyonships(X)) & powerfulsteamturbine(X))))).
fof(p3, axiom, ! [X] : ((((passenger(X) & vessel(X)) & (cargo(X) & vessel(X))) => (quiet(X) & goodat(X, sea))))).
fof(p4, axiom, ? [X] : (((quiet(X) & goodat(X, sea)) & powerfulsteamturbine(X)))).
fof(p5, axiom, ! [X] : ((ship(X) => vessel(X)))).
fof(extra1, axiom, ~(! [X] : ((tsleda(X) => (quiet(X) & goodat(X, sea)))))).
