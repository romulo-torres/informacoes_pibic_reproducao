% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((mushroom(X) => fungi(X)))).
fof(extra1, axiom, ~(! [X] : ((plant(X) => ~(mushroom(X)))))).
