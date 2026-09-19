% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((book(X) & writtenby(X, cixinliu)) => ? [Y] : ((morethan(Y, onemillion) & sold(X, Y)))))).
fof(p2, axiom, ? [X] : (((won(X, hugoaward) & book(X)) & writtenby(X, cixinliu)))).
fof(p3, axiom, ! [X] : (((book(X) & aboutfuture(X)) => fowardlooking(X)))).
fof(p4, axiom, (book(threebodyproblem) & ? [Y] : ((morethan(Y, onemillion) & sold(threebodyproblem, Y))))).
fof(extra1, axiom, (aboutfuture(threebodyproblem))).
