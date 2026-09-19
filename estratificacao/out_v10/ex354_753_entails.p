% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((road(X) => (madeof(X, concrete) <~> madeof(X, asphalt))))).
fof(p2, axiom, ! [X] : (! [Y] : (((((road(X) & madeof(X, concrete)) & road(Y)) & madeof(Y, asphalt)) => lastlonger(X, Y))))).
fof(p3, axiom, ! [X] : (! [Y] : (((((road(X) & madeof(X, asphalt)) & road(Y)) & madeof(Y, concrete)) => smoother(X, Y))))).
fof(p4, axiom, ! [X] : (! [Y] : (! [Z] : ((((road(X) & road(Y)) & smoother(X, Y)) => prefer(Z, X)))))).
fof(p5, axiom, (((road(firstroad) & madeof(secondroad, concrete)) & road(firstroad)) & madeof(secondroad, asphalt))).
fof(extra1, axiom, ~(prefer(john, secondroad))).
