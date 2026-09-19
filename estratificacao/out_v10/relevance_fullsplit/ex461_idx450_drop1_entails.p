% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (! [Y] : (((student(X) & getgradein(X, aplus, englishclass)) => (englishclassscore(X, Y) & greaterthan95(Y)))))).
fof(p2, axiom, ! [X] : (! [Y] : (((student(X) & getgradein(X, a, englishclass)) => ((englishclassscore(X, Y) & greaterthan90(Y)) & lowerthan95(Y)))))).
fof(p3, axiom, (student(zhang) & getgradein(zhang, a, englishclass))).
fof(p4, axiom, ! [X] : (! [Y] : (((((student(zhang) & student(wang)) & englishscore(zhang, X)) & englishscore(wang, Y)) & better(Y, X))))).
fof(p5, axiom, ! [X] : (((student(wu) & englishscore(wu, X)) & lowerthan90(X)))).
fof(p6, axiom, ! [X] : (! [Y] : ((((student(X) & englishscore(X, Y)) & lowerthan90(Y)) => ((~(greaterthan95(Y)) & ~(greaterthan90(Y))) & lowerthan95(Y)))))).
fof(extra1, axiom, ~(! [X] : ((englishscore(zhang, X) & lowerthan95(X))))).
