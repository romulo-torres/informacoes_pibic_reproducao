% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, produces(columbiapictures, adventuresofrusty)).
fof(p2, axiom, produces(paramount, tintin)).
fof(p3, axiom, adventurefilm(tintin)).
fof(extra1, axiom, (? [X] : ((adventurefilm(X) & produces(paramount, X))))).
