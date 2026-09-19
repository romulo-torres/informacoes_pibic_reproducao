% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (movie(endgame) & released(endgame, yr2006))).
fof(p2, axiom, setin(endgame, washington)).
fof(p3, axiom, ~(filmedin(endgame, washington))).
fof(p4, axiom, directed(andychang, endgame)).
fof(p5, axiom, from(andychang, hongkong)).
fof(extra1, axiom, ~(! [X] : (~((directed(X, endgame) & from(X, hongkong)))))).
