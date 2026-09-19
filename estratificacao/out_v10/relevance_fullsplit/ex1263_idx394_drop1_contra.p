% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((osprey(X) => bird(X)))).
fof(p2, axiom, ! [X] : ((carp(X) => fish(X)))).
fof(p3, axiom, ! [X] : ((goldfish(X) => carp(X)))).
fof(p4, axiom, ((osprey(bubbles) <~> goldfish(bubbles)) => ~(fish(bubbles)))).
fof(extra1, axiom, (~(goldfish(bubbles)))).
