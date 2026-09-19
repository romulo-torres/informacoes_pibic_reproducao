% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((take(X, barexam) => canread(X)))).
fof(p2, axiom, ! [X] : ((lawyer(X) => take(X, barexam)))).
fof(p3, axiom, ! [X] : ((take(X, barexam) => knowledgeableabout(X, criminalproceeder)))).
fof(p4, axiom, ! [X] : ((geton(X, scoreof180, lsat) => canread(X)))).
fof(p5, axiom, ! [X] : ((elephant(X) => ~(canread(X))))).
fof(p6, axiom, (~((canread(mike) & elephant(mike))) => (take(mike, barexam) <~> canread(mike)))).
fof(extra1, axiom, (geton(mike, num180, lsat))).
