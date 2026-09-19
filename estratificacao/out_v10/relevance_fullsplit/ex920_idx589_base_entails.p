% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((mammal(X) => livingbeing(X)))).
fof(p2, axiom, ! [X] : ((elephant(X) => mammal(X)))).
fof(p3, axiom, ! [X] : ((babyelephant(X) => elephant(X)))).
fof(p4, axiom, ? [X] : ((babyelephant(X) & sleepy(X)))).
fof(p5, axiom, (livingbeing(jumbo) => ~((elephant(jumbo) & mammal(jumbo))))).
fof(p6, axiom, (sleepy(jumbo) => (babyelephant(jumbo) <~> mammal(jumbo)))).
fof(extra1, axiom, ~(~((sleepy(jumbo) <~> elephant(jumbo))))).
