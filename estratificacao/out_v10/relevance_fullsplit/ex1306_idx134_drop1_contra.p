% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((penguin(X) => bird(X)))).
fof(p2, axiom, ! [X] : ((animal(X) => (ectothermic(X) | endothermic(X))))).
fof(p3, axiom, ! [X] : ((endothermic(X) => producewithin(X, heat, body)))).
fof(p4, axiom, (animal(ron) & animal(henry))).
fof(p5, axiom, (~(bird(ron)) & ~(producewithin(ron, heat, body)))).
fof(p6, axiom, (~(cat(henry)) & ~(producewithin(henry, heat, body)))).
fof(extra1, axiom, (~((penguin(ron) <~> endothermic(henry))))).
