% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (! [Y] : ((((person(X) & product(Y)) & ~(haveenoughmoneyfor(X, Y))) => ~(buy(X, Y)))))).
fof(p2, axiom, ! [X] : ((monitor(X) => product(X)))).
fof(p3, axiom, ! [X] : (! [Y] : (! [Z] : (((((((monitor(X) & monitor(Y)) & monitor(Z)) & fourk(X)) & oneoeighto(Y)) & twok(Z)) => (moreexpensive(X, Y) & moreexpensive(X, Z))))))).
fof(p4, axiom, person(john)).
fof(p5, axiom, ! [X] : (((monitor(X) & twok(X)) => ~(haveenoughmoneyfor(john, X))))).
fof(extra1, axiom, ~(! [X] : (((monitor(X) & oneoeighto(X)) => ~(buy(john, X)))))).
