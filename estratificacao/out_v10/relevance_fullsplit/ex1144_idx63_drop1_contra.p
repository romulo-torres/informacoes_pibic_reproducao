% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((grownin(X, bensyard) & is(X, apple)) => redfruit(X)))).
fof(p2, axiom, ! [X] : (((grownin(X, bensyard) & contain(X, vitaminc)) => healthy(X)))).
fof(p3, axiom, ! [X] : (((grownin(X, bensyard) & healthy(X)) => ~(on(X, warninglist))))).
fof(p4, axiom, grownin(cherry, bensyard)).
fof(p5, axiom, (~((healthy(cherry) & is(cherry, apple))) => redfruit(cherry))).
fof(extra1, axiom, ((on(cherry, warninglist) <~> redfruit(cherry)))).
