% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((leader(X) => havepower(X)))).
fof(p2, axiom, ! [X] : ((queen(X) => female(X)))).
fof(p3, axiom, ! [X] : ((king(X) => male(X)))).
fof(p4, axiom, queen(elizabeth)).
fof(p5, axiom, leader(elizabeth)).
fof(extra1, axiom, ~(king(elizabeth))).
