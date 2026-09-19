% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((pet(X) => animal(X)))).
fof(p2, axiom, ! [X] : ((pet(X) => (dog(X) <~> cat(X))))).
fof(p3, axiom, ! [X] : (! [Y] : (((pet(Y) & ownedby(X, Y)) => cares(X, Y))))).
fof(p4, axiom, ? [X] : (? [Y] : (((((cat(X) & naughty(X)) & ~((X = Y))) & dog(Y)) & naughty(Y))))).
fof(p5, axiom, ! [X] : (! [Y] : ((((pet(X) & naughty(X)) & ownedby(X, Y)) => ~(liked(X, Y)))))).
fof(extra1, axiom, (! [X] : ((dog(X) => ~(naughty(X)))))).
