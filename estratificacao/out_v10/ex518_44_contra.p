% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : ((project(X) & do(sam, X)))).
fof(p2, axiom, ! [X] : ((project(X) => (writtenin(X, cplusplus) <~> writtenin(X, python))))).
fof(p3, axiom, ! [X] : ((((project(X) & writtenin(X, python)) & do(sam, X)) => ~(use(sam, mac))))).
fof(p4, axiom, use(sam, mac)).
fof(p5, axiom, ? [X] : (((use(sam, mac) & song(X)) => play(sam, X)))).
fof(p6, axiom, ! [X] : (((song(X) & play(sam, X)) => titled(X, perfect)))).
fof(extra1, axiom, (! [X] : (((project(X) & do(sam, X)) & writtenin(X, cplusplus))))).
