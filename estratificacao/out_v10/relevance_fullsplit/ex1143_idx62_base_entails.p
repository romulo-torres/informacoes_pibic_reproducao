% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((grownin(X, bensyard) & redfruit(X)) => contain(X, vitaminc)))).
fof(p2, axiom, ! [X] : (((grownin(X, bensyard) & is(X, apple)) => redfruit(X)))).
fof(p3, axiom, ! [X] : (((grownin(X, bensyard) & contain(X, vitaminc)) => healthy(X)))).
fof(p4, axiom, ! [X] : (((grownin(X, bensyard) & healthy(X)) => ~(on(X, warninglist))))).
fof(p5, axiom, grownin(cherry, bensyard)).
fof(p6, axiom, (~((healthy(cherry) & is(cherry, apple))) => redfruit(cherry))).
fof(extra1, axiom, ~((contain(cherry, vitaminc) <~> on(cherry, warninglist)))).
