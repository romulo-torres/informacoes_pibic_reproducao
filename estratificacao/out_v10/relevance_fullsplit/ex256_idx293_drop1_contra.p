% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : ((((earthquake(X) & strikeinyr(X, year1999)) & strikeinmo(X, december)) & strikeincity(X, luzon)))).
fof(p2, axiom, ? [X] : (((((earthquake(X) & strikeinyr(X, year1999)) & strikeinmo(X, december)) & strikeincity(X, luzon)) & deadly(X)))).
fof(extra1, axiom, (! [X] : (! [Y] : ((((earthquake(X) & strikeincity(X, Y)) & in(Y, philippines)) => ~(deadly(X))))))).
