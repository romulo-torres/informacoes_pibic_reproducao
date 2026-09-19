% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((monitor(X) => product(X)))).
fof(p2, axiom, ! [X] : (! [Y] : (! [Z] : (((((((monitor(X) & monitor(Y)) & monitor(Z)) & fourk(X)) & oneoeighto(Y)) & twok(Z)) => (moreexpensive(X, Y) & moreexpensive(X, Z))))))).
fof(p3, axiom, person(john)).
fof(p4, axiom, ! [X] : (((monitor(X) & twok(X)) => ~(haveenoughmoneyfor(john, X))))).
fof(extra1, axiom, ~(! [X] : (((monitor(X) & twok(X)) => ~(buy(john, X)))))).
