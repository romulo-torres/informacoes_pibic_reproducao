% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (goto(sarah, vermont) => driveto(sarah, vermont))).
fof(p2, axiom, ! [X] : (! [Y] : (((~(own(X, car)) & driveto(X, Y)) => (borrow(X, car) <~> rent(X, car)))))).
fof(p3, axiom, ~(own(sarah, car))).
fof(p4, axiom, ! [X] : ((camping(sarah, X) => ~(borrow(sarah, car))))).
fof(p5, axiom, camping(sarah, vermont)).
fof(p6, axiom, ! [X] : (! [Y] : ((camping(X, Y) => goto(X, Y))))).
fof(extra1, axiom, ~(spend(sarah, money))).
