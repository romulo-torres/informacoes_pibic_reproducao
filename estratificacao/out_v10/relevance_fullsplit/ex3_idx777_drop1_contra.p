% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((has(X, flu) => has(X, influenza)))).
fof(p2, axiom, ~(has(susan, influenza))).
fof(extra1, axiom, ((has(mary, influenza) <~> has(susan, influenza)))).
