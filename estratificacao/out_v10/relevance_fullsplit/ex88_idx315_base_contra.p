% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (movie(endgame) & released(endgame, yr2006))).
fof(p2, axiom, setin(endgame, washington)).
fof(p3, axiom, ~(filmedin(endgame, washington))).
fof(p4, axiom, ? [X] : (? [Y] : (((filmedin(X, newyork) & ~((X = Y))) & filmedin(Y, newyork))))).
fof(p5, axiom, directed(andychang, endgame)).
fof(p6, axiom, from(andychang, hongkong)).
fof(extra1, axiom, (! [X] : ((directed(andychang, X) => ~(filmedin(X, washington)))))).
