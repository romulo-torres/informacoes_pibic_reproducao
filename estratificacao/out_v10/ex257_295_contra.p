% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (island(luzon) & in(luzon, philippines))).
fof(p2, axiom, ? [X] : ((((earthquake(X) & strikeinyr(X, year1999)) & strikeinmo(X, december)) & strikeincity(X, luzon)))).
fof(p3, axiom, ? [X] : (((((earthquake(X) & strikeinyr(X, year1999)) & strikeinmo(X, december)) & strikeincity(X, luzon)) & deadly(X)))).
fof(extra1, axiom, (? [X] : (? [Y] : (((((earthquake(X) & strikeinyr(X, year1999)) & strikeinmo(X, december)) & strikeincity(X, Y)) & in(Y, philippines)))))).
