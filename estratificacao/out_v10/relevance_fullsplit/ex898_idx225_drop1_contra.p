% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((digitalwatch(X) => batterypoweredwatch(X)))).
fof(p2, axiom, ? [X] : ((mechanicalwatch(X) & automaticwatch(X)))).
fof(p3, axiom, ! [X] : ((smartwatch(X) => digitalwatch(X)))).
fof(p4, axiom, ~((digitalwatch(moonwatch) <~> automaticwatch(moonwatch)))).
fof(extra1, axiom, (((smartwatch(moonwatch) & mechanicalwatch(moonwatch)) => ~(mechanicalwatch(moonwatch))))).
