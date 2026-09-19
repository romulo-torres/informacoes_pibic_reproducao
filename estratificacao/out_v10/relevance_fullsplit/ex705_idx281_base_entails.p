% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((nuclearpoweredsubmarine(X) => warship(X)))).
fof(p2, axiom, ! [X] : ((nuclearpoweredsubmarine(X) => ~(commercialvessel(X))))).
fof(extra1, axiom, ~(! [X] : ((warship(X) => ~(commercialvessel(X)))))).
