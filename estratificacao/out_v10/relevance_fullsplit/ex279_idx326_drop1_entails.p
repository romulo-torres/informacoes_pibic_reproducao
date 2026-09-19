% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, produces(columbiapictures, adventuresofrusty)).
fof(p2, axiom, produces(paramount, tintin)).
fof(p3, axiom, adventurefilm(tintin)).
fof(extra1, axiom, ~(? [X] : ((dramafilm(X) & produces(columbiapictures, X))))).
