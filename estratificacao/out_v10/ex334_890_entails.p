% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (scottish(stjohnstone) & team(stjohnstone))).
fof(p2, axiom, (partof(stjohnstone, scottishpremiership) & league(scottishpremiership))).
fof(p3, axiom, ! [X] : (! [Y] : ((((team(X) & league(Y)) & partof(X, Y)) => joined(X, Y))))).
fof(p4, axiom, ~((misnk = stjohnstone))).
fof(p5, axiom, ! [X] : (! [Y] : ((~((X = Y)) => (wonagainst(X, Y) <~> wonagainst(Y, X)))))).
fof(p6, axiom, wonagainst(minsk, stjohnstone)).
fof(extra1, axiom, ~(wongame(stjohnstone, minsk))).
