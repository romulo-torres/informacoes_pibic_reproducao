% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ~(? [X] : (((languagemodel(X) & giant(X)) & ~(goodperformance(X)))))).
fof(p2, axiom, ! [X] : (? [Y] : (? [Z] : (((languagemodel(X) & goodperformance(X)) => ((((~((X = Y)) & researcher(Y)) & usedby(X, Y)) & researcher(Z)) & usedby(X, Z))))))).
fof(p3, axiom, ! [X] : (? [Y] : (? [Z] : (((((((languagemodel(X) & ~((X = Y))) & researcher(Y)) & usedby(X, Y)) & researcher(Z)) & usedby(X, Z)) => popular(X)))))).
fof(p4, axiom, ((languagemodel(bert) & giant(bert)) => (languagemodel(gpt_3) & giant(gpt_3)))).
fof(p5, axiom, (languagemodel(bert) & giant(bert))).
fof(extra1, axiom, ~(popular(gpt_3))).
