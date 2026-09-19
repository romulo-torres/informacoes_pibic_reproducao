% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((bird(X) => ~(ectothermic(X))))).
fof(p2, axiom, ! [X] : ((penguin(X) => bird(X)))).
fof(p3, axiom, ! [X] : ((animal(X) => (ectothermic(X) | endothermic(X))))).
fof(p4, axiom, ! [X] : ((endothermic(X) => producewithin(X, heat, body)))).
fof(p5, axiom, (animal(ron) & animal(henry))).
fof(p6, axiom, (~(bird(ron)) & ~(producewithin(ron, heat, body)))).
fof(p7, axiom, (~(cat(henry)) & ~(producewithin(henry, heat, body)))).
fof(extra1, axiom, ~((penguin(henry) <~> endothermic(henry)))).
