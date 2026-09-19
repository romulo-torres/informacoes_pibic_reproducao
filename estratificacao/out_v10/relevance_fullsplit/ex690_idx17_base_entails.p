% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, universallanguage(languagea)).
fof(p2, axiom, ! [X] : (! [Y] : ((? [Z] : ((((~((X = Y)) & know(X, Z)) & know(Y, Z)) & universallanguage(Z))) => (cancommunicatewith(X, Y) & cancommunicatewith(Y, X)))))).
fof(p3, axiom, ~(cancommunicatewith(katya, danil))).
fof(p4, axiom, know(katya, languagea)).
fof(extra1, axiom, ~(know(danil, languagea))).
