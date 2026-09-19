% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((controlledsubstances(X) => drugs(X)))).
fof(p2, axiom, ! [X] : (! [Y] : ((((child(X) & controlledsubstances(Y)) & exposedto(X, Y)) => inchemicalendangerment(X))))).
fof(p3, axiom, ! [X] : ((inchemicalendangerment(X) => harmful(X)))).
fof(p4, axiom, (passedin(controlledsubstancesact, yr1971) & act(controlledsubstancesact))).
fof(p5, axiom, ? [X] : (? [Y] : (((((act(X) & preventsharm(X)) & ~((X = Y))) & act(Y)) & preventsharm(Y))))).
fof(extra1, axiom, ~(! [X] : (((child(X) & inchemicalendangerment(X)) => harmful(X))))).
