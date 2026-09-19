% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((cat(X) => mammal(X)))).
fof(extra1, axiom, ~(? [X] : (? [Y] : ((((mammal(X) & mammal(Y)) & ~(pet(X))) & ~(pet(Y))))))).
