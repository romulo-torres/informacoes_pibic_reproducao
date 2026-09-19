% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (! [Y] : (((handbrakeof(X, Y) & car(Y)) => (up(X) <~> down(X)))))).
fof(p2, axiom, ! [X] : (! [Y] : ((((handbrakeof(X, Y) & parked(Y)) & car(Y)) => down(X))))).
fof(extra1, axiom, (? [X] : (? [Y] : ((((handbrakeof(X, Y) & parked(Y)) & car(Y)) & up(X)))))).
