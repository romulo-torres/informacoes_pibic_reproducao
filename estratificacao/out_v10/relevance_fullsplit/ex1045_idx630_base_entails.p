% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((element(X) & ? [Y] : ((between(Y, num61, num63) & atomicnumber(X, Y)))) => scarcein(X, china)))).
fof(p2, axiom, ! [X] : ((~(rareearthelement(X)) => ~(scarcein(X, china))))).
fof(p3, axiom, ! [X] : ((~(rareearthelement(X)) <~> rareearthelement(X)))).
fof(p4, axiom, ! [X] : ((rareearthelement(X) => usedin(X, industry)))).
fof(p5, axiom, ! [X] : ((rareearthelement(X) => essentialfor(X, electronics)))).
fof(p6, axiom, ~((~(rareearthelement(lithium)) <~> essentialfor(lithium, electronics)))).
fof(extra1, axiom, ~(((element(x) & ? [Y] : ((between(Y, num61, num63) & atomicnumber(x, Y)))) & usedfor(lithium, batteries)))).
