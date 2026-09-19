% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((cellphone(X) => phone(X)))).
fof(p2, axiom, ! [X] : ((iphone(X) => cellphone(X)))).
fof(p3, axiom, ! [X] : ((employee(X) => wageearner(X)))).
fof(p4, axiom, ! [X] : ((wageearner(X) => human(X)))).
fof(p5, axiom, (employee(jack) <~> wageearner(jack))).
fof(p6, axiom, (human(jack) <~> phone(jack))).
fof(extra1, axiom, (~((thing(jack) & iphone(jack))))).
