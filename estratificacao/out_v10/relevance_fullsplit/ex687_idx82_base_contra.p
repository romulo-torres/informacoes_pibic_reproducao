% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((rent(X, car) => spend(X, money)))).
fof(p2, axiom, (goto(sarah, vermont) => driveto(sarah, vermont))).
fof(p3, axiom, ! [X] : (! [Y] : (((~(own(X, car)) & driveto(X, Y)) => (borrow(X, car) <~> rent(X, car)))))).
fof(p4, axiom, ~(own(sarah, car))).
fof(p5, axiom, ! [X] : ((camping(sarah, X) => ~(borrow(sarah, car))))).
fof(p6, axiom, camping(sarah, vermont)).
fof(p7, axiom, ! [X] : (! [Y] : ((camping(X, Y) => goto(X, Y))))).
fof(extra1, axiom, (spend(sarah, money))).
