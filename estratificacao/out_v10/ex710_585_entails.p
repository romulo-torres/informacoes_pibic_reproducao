% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((cdplayer(X) => delicatemechanism(X)))).
fof(p2, axiom, ! [X] : ((delicatemechanism(X) => ~((toy(X) & suitablefor(X, children)))))).
fof(extra1, axiom, ~(? [X] : (? [Y] : (((((((cdplayer(X) & cdplayer(Y)) & toy(X)) & toy(Y)) & suitablefor(X, children)) & suitablefor(Y, children)) & ~((X = Y))))))).
