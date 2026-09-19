% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, has(mary, flu)).
fof(p2, axiom, ! [X] : ((has(X, flu) => has(X, influenza)))).
fof(p3, axiom, ~(has(susan, influenza))).
fof(extra1, axiom, ((has(mary, influenza) <~> has(susan, influenza)))).
