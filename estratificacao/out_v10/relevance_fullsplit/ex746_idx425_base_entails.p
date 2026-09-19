% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ? [X] : ((artpiece(X) & ~(require(X, talent))))).
fof(p2, axiom, ! [X] : ((require(X, talent) => require(X, practice)))).
fof(extra1, axiom, ~(? [X] : (? [Y] : (((((artpiece(X) & ~(require(X, practice))) & artpiece(Y)) & ~(require(Y, practice))) & ~((X = Y))))))).
