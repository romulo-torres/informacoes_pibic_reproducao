% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (dramafilm(adventuresofrusty) & childrensfilm(adventuresofrusty))).
fof(p2, axiom, produces(columbiapictures, adventuresofrusty)).
fof(p3, axiom, produces(paramount, tintin)).
fof(p4, axiom, adventurefilm(tintin)).
fof(extra1, axiom, ~(? [X] : ((adventurefilm(X) & produces(columbiapictures, X))))).
