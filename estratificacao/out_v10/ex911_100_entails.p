% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((kid(X) => young(X)))).
fof(p2, axiom, ! [X] : ((toddler(X) => kid(X)))).
fof(p3, axiom, ! [X] : ((young(X) => ~(elderly(X))))).
fof(p4, axiom, ! [X] : ((pirate(X) => seafarer(X)))).
fof(p5, axiom, (~(pirate(nancy)) => young(nancy))).
fof(p6, axiom, (~(toddler(nancy)) => seafarer(nancy))).
fof(extra1, axiom, ~(~((pirate(nancy) <~> toddler(nancy))))).
