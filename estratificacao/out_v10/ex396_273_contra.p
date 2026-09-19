% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (speedway(islip) & smallestracetrack(islip))).
fof(p2, axiom, ? [X] : (? [Y] : (((demolitionderby(X) & smallestracetrack(Y)) & on(X, Y))))).
fof(p3, axiom, (demolished(islip) <~> stillused(islip))).
fof(p4, axiom, ! [X] : (((speedway(X) & stillused(X)) => have(races, heldat, X)))).
fof(p5, axiom, ~(have(races, heldat, islip))).
fof(extra1, axiom, (demolished(islip))).
