% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((phone(X) => thing(X)))).
fof(p2, axiom, ! [X] : ((cellphone(X) => phone(X)))).
fof(p3, axiom, ! [X] : ((iphone(X) => cellphone(X)))).
fof(p4, axiom, ! [X] : ((employee(X) => wageearner(X)))).
fof(p5, axiom, ! [X] : ((wageearner(X) => human(X)))).
fof(p6, axiom, (employee(jack) <~> wageearner(jack))).
fof(p7, axiom, (human(jack) <~> phone(jack))).
fof(extra1, axiom, ~((thing(jack) & iphone(jack)))).
