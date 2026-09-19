% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, albumsreleased(phoenix, num6)).
fof(p2, axiom, ((album(wolfgangamadeusphoenix) & isalbumof(wolfgangamadeusphoenix, phoenix)) & soldover(wolfgangamadeusphoenix, num500, num000))).
fof(p3, axiom, ! [X] : ((((album(X) | single(X)) & soldover(X, num500, num000)) => certifiedgold(X)))).
fof(p4, axiom, ((single(num1901) & from(num1901, wolfgangamadeusphoenix)) & by(num1901, phoenix))).
fof(p5, axiom, soldover(l1901, num400, num000)).
fof(extra1, axiom, (certifiedgold(wolfgangamadeusphoenix))).
