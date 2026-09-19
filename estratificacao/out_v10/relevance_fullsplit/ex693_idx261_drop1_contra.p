% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : ((~(chef(X)) & can(X, cook)))).
fof(p2, axiom, ! [X] : ((can(X, cook) => (canmake(X, scrambledeggs) & canmake(X, pasta))))).
fof(p3, axiom, ! [X] : (((canmake(X, cookies) & canmake(X, muffins)) => baker(X)))).
fof(p4, axiom, ! [X] : (((baker(X) & canmake(X, scrambledeggs)) => canmake(X, goodbreakfast)))).
fof(p5, axiom, (canmake(luke, cookies) & ((canmake(luke, scrambledeggs) & canmake(luke, muffins)) & ~(canmake(luke, pasta))))).
fof(extra1, axiom, (chef(luke))).
