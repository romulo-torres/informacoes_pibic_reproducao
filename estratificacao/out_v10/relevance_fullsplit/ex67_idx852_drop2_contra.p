% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((book(X) & writtenby(X, cixinliu)) => ? [Y] : ((morethan(Y, onemillion) & sold(X, Y)))))).
fof(p2, axiom, ! [X] : (((book(X) & aboutfuture(X)) => fowardlooking(X)))).
fof(p3, axiom, (book(threebodyproblem) & ? [Y] : ((morethan(Y, onemillion) & sold(threebodyproblem, Y))))).
fof(p4, axiom, aboutfuture(threebodyproblem)).
fof(extra1, axiom, (aboutfuture(threebodyproblem))).
