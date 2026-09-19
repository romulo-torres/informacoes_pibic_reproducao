% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ? [X] : (((won(X, hugoaward) & book(X)) & writtenby(X, cixinliu)))).
fof(p2, axiom, ! [X] : (((book(X) & aboutfuture(X)) => fowardlooking(X)))).
fof(p3, axiom, (book(threebodyproblem) & ? [Y] : ((morethan(Y, onemillion) & sold(threebodyproblem, Y))))).
fof(p4, axiom, aboutfuture(threebodyproblem)).
fof(extra1, axiom, ~(aboutfuture(threebodyproblem))).
