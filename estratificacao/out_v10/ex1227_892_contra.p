% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((plane(X) & boeing737(X)) => ~(? [Y] : ((greaterthan(Y, num300) & equippedwithseats(X, Y))))))).
fof(p2, axiom, ! [X] : (((plane(X) & acquiredby(X, delta)) => boeing737(X)))).
fof(p3, axiom, ! [X] : ((plane(X) => (? [Y] : ((greaterthan(Y, num300) & equippedwithseats(X, Y))) <~> ? [Y] : ((equals(Y, num100) & equippedwithseats(X, Y))))))).
fof(p4, axiom, ! [X] : (((plane(X) & ? [Y] : ((equals(Y, num100) & equippedwithseats(X, Y)))) => scheduledfor(X, shortdistanceflight)))).
fof(p5, axiom, ! [X] : (((plane(X) & ? [Y] : ((equals(Y, num100) & equippedwithseats(X, Y)))) => ? [Z] : ((before(Z, yr2010) & produced(X, Z)))))).
fof(p6, axiom, ((boeing737(jake32) & plane(jake32)) <~> (acquiredbydeltainthisbatch(jake32) & plane(jake32)))).
fof(p7, axiom, ~(((boeing737(t10) & plane(t10)) <~> (acquiredbydeltainthisbatch(t10) & plane(t10))))).
fof(extra1, axiom, ((? [Z] : ((before(Z, year2010) & produced(jake32, Z))) & scheduledfor(jake32, shortdistanceflight)))).
