% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, opensourcesoftware(drishti)).
fof(p2, axiom, ! [X] : ((opensourcesoftware(X) => freetomodify(X)))).
fof(extra1, axiom, ~(freetomodify(drishti))).
