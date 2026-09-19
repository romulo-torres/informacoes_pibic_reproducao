% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (! [Y] : (! [Z] : (((((class(X) & student(Y)) & prereq(Z, X)) & ~(take(Y, Z))) => ~(cantake(Y, X))))))).
fof(p2, axiom, ! [X] : (! [Y] : ((((class(X) & student(Y)) & ~(? [Z] : (prereq(Z, X)))) => cantake(Y, X))))).
fof(p3, axiom, (prereq(cpsc201, cpsc323) & prereq(cpsc223, cpsc323))).
fof(p4, axiom, ! [X] : ((prereq(X, intermediatemicro) => (X = intromicroeconomics)))).
fof(p5, axiom, ~(? [X] : (prereq(X, introgeology)))).
fof(extra1, axiom, ~(? [X] : ((taken(X) => cantake(intermediatemicro))))).
