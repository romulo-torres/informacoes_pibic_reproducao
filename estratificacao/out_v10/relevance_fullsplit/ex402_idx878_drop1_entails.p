% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((greyhoundracing(X) => coursing(X)))).
fof(p2, axiom, ? [X] : (? [Y] : (((competitivesport(X) & beton(spectators, Y, X)) & banned(X))))).
fof(p3, axiom, ! [X] : (? [Y] : (? [Z] : ((coursing(X) => (((hare(Y) & beton(spectators, Y, X)) & greyhound(Z)) & pursuedby(Y, Z))))))).
fof(p4, axiom, ? [X] : (! [Y] : (((hare(X) & beton(spectators, X, Y)) => smallgame(Y))))).
fof(p5, axiom, ! [X] : (? [Y] : ((((competitivesport(X) & smallgame(Y)) & beton(spectators, Y, X)) => banned(X))))).
fof(extra1, axiom, ~(! [X] : ((coursing(X) & ~(banned(X)))))).
