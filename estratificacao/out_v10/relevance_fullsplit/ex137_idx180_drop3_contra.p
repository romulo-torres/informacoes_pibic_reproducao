% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((controlledsubstances(X) => drugs(X)))).
fof(p2, axiom, ? [X] : (? [Y] : (((((controlledsubstances(X) & controlledsubstances(Y)) & ~((X = Y))) & beneficial(X)) & harmful(Y))))).
fof(p3, axiom, ! [X] : ((inchemicalendangerment(X) => harmful(X)))).
fof(p4, axiom, (passedin(controlledsubstancesact, yr1971) & act(controlledsubstancesact))).
fof(p5, axiom, ? [X] : (? [Y] : (((((act(X) & preventsharm(X)) & ~((X = Y))) & act(Y)) & preventsharm(Y))))).
fof(extra1, axiom, (! [X] : (((child(X) & inchemicalendangerment(X)) => harmful(X))))).
