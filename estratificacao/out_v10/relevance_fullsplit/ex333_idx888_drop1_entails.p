% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (partof(stjohnstone, scottishpremiership) & league(scottishpremiership))).
fof(p2, axiom, ! [X] : (! [Y] : ((((team(X) & league(Y)) & partof(X, Y)) => joined(X, Y))))).
fof(p3, axiom, ~((misnk = stjohnstone))).
fof(p4, axiom, ! [X] : (! [Y] : ((~((X = Y)) => (wonagainst(X, Y) <~> wonagainst(Y, X)))))).
fof(p5, axiom, wonagainst(minsk, stjohnstone)).
fof(extra1, axiom, ~(? [X] : ((scottish(X) & joined(X, scottishpremiership))))).
