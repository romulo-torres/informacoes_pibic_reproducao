% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((homework(X) => ~(fun(X))))).
fof(p2, axiom, ? [X] : ((reading(X) & homework(X)))).
fof(extra1, axiom, (? [X] : ((reading(X) & fun(X))))).
