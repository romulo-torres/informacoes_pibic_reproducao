% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (dramafilm(adventuresofrusty) & childrensfilm(adventuresofrusty))).
fof(p2, axiom, produces(columbiapictures, adventuresofrusty)).
fof(p3, axiom, adventurefilm(tintin)).
fof(extra1, axiom, ~(? [X] : ((adventurefilm(X) & produces(paramount, X))))).
