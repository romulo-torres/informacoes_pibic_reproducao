% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ((album(wolfgangamadeusphoenix) & isalbumof(wolfgangamadeusphoenix, phoenix)) & soldover(wolfgangamadeusphoenix, num500, num000))).
fof(p2, axiom, ! [X] : ((((album(X) | single(X)) & soldover(X, num500, num000)) => certifiedgold(X)))).
fof(p3, axiom, ((single(num1901) & from(num1901, wolfgangamadeusphoenix)) & by(num1901, phoenix))).
fof(p4, axiom, soldover(l1901, num400, num000)).
fof(extra1, axiom, ~(certifiedgold(wolfgangamadeusphoenix))).
