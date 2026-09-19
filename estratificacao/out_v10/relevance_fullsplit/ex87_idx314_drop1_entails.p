% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, setin(endgame, washington)).
fof(p2, axiom, ~(filmedin(endgame, washington))).
fof(p3, axiom, ? [X] : (? [Y] : (((filmedin(X, newyork) & ~((X = Y))) & filmedin(Y, newyork))))).
fof(p4, axiom, directed(andychang, endgame)).
fof(p5, axiom, from(andychang, hongkong)).
fof(extra1, axiom, ~(! [X] : (~((directed(X, endgame) & from(X, hongkong)))))).
