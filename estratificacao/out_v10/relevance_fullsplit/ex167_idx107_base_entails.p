% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((leader(X) => havepower(X)))).
fof(p2, axiom, ! [X] : ((leader(X) => (king(X) <~> queen(X))))).
fof(p3, axiom, ! [X] : ((queen(X) => female(X)))).
fof(p4, axiom, ! [X] : ((king(X) => male(X)))).
fof(p5, axiom, queen(elizabeth)).
fof(p6, axiom, leader(elizabeth)).
fof(extra1, axiom, ~(leader(elizabeth))).
