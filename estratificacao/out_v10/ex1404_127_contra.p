% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((biodegradable(X) => environmentfriendly(X)))).
fof(p2, axiom, ! [X] : ((woodware(X) => biodegradable(X)))).
fof(p3, axiom, ! [X] : ((paper(X) => woodware(X)))).
fof(p4, axiom, ~(? [X] : ((good(X) & bad(X))))).
fof(p5, axiom, ! [X] : ((environmentfriendly(X) => good(X)))).
fof(p6, axiom, (paper(worksheet) <~> environmentfriendly(worksheet))).
fof(extra1, axiom, (bad(worksheet))).
