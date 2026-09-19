% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((animal(X) & ? [Y] : (? [Z] : (((((~((Y = Z)) & wing(Y)) & wing(Z)) & have(X, Y)) & have(X, Z))))) => ~(reptile(X))))).
fof(p2, axiom, ? [X] : (((animal(X) & fly(X)) & bird(X)))).
fof(p3, axiom, ! [X] : ((iguana(X) => reptile(X)))).
fof(p4, axiom, ~((iguana(john) <~> bird(john)))).
fof(p5, axiom, animal(john)).
fof(extra1, axiom, (~((iguana(john) & fly(john))))).
