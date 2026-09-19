% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((? [Y] : (((livein(X, Y) & place(Y)) & named(Y, galicia))) => (livein(X, spain) <~> livein(X, poland))))).
fof(p2, axiom, ! [X] : ((livein(X, spain) => livein(X, europe)))).
fof(p3, axiom, ! [X] : ((livein(X, poland) => livein(X, europe)))).
fof(p4, axiom, livein(rochelle, europe)).
fof(p5, axiom, ~(livein(dominique, europe))).
fof(p6, axiom, ? [Y] : (((livein(alfonso, Y) & place(Y)) & named(Y, galicia)))).
fof(extra1, axiom, ~(! [X] : ((live(alfonso, X) => in(X, europe))))).
