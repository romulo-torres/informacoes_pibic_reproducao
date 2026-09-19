% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((have(X, corporatejob) => ~(take(X, financialrisk))))).
fof(p2, axiom, ! [X] : ((entrepreneur(X) => take(X, financialrisk)))).
fof(p3, axiom, ! [X] : ((riskaverse(X) => have(X, corporatejob)))).
fof(p4, axiom, ! [X] : ((? [Y] : (? [Z] : (((((~((Y = X)) & ~((Z = X))) & ~((Y = Z))) & hateworkingfor(X, Y)) & hateworkingfor(X, Z)))) => entrepreneur(X)))).
fof(p5, axiom, ((~(entrepreneur(markzuckerberg)) & ~(? [Y] : (? [Z] : (((((~((Y = markzuckerberg)) & ~((Z = markzuckerberg))) & ~((Y = Z))) & hateworkingfor(markzuckerberg, Y)) & hateworkingfor(markzuckerberg, Z)))))) => ~(riskaverse(markzuckerberg)))).
fof(extra1, axiom, (entrepreneur(markzuckerberg))).
