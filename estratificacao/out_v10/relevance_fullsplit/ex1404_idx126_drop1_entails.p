% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((woodware(X) => biodegradable(X)))).
fof(p2, axiom, ! [X] : ((paper(X) => woodware(X)))).
fof(p3, axiom, ~(? [X] : ((good(X) & bad(X))))).
fof(p4, axiom, ! [X] : ((environmentfriendly(X) => good(X)))).
fof(p5, axiom, (paper(worksheet) <~> environmentfriendly(worksheet))).
fof(extra1, axiom, ~(bad(worksheet))).
