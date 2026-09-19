% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((sandwichcookie(X) => ~(healthy(X))))).
fof(p2, axiom, ! [X] : ((oreo(X) => sandwichcookie(X)))).
fof(extra1, axiom, ~(! [X] : ((sandwichcookie(X) => delicious(X))))).
