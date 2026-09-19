% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (system(playstation2) & cameraaccessoryfor(playstationeyetoy, playstation2))).
fof(p2, axiom, (system(playstation3) & cameraaccessoryfor(playstationeye, playstation3))).
fof(p3, axiom, (((system(playstation4) & system(playstation5)) & cameraaccessoryfor(playstationcamera, playstation4)) & cameraaccessoryfor(playstationcamera, playstation5))).
fof(p4, axiom, ! [X] : (! [Y] : (((cameraaccessoryfor(X, Y) & system(Y)) => compatiblewith(X, Y))))).
fof(p5, axiom, (((((~((playstation2 = playstation3)) & ~((playstation2 = playstation4))) & ~((playstation2 = playstation5))) & ~((playstation3 = playstation4))) & ~((playstation3 = playstation5))) & ~((playstation4 = playstation5)))).
fof(p6, axiom, ! [X] : (? [Y] : (? [Z] : ((((((system(Y) & system(Z)) & ~((Y = Z))) & compatiblewith(X, Y)) & compatiblewith(X, Z)) => (X = playstationcamera)))))).
fof(extra1, axiom, ((compatible(playstationeye, playstation2) & compatible(playstationeye, playstation3)))).
