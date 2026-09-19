% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, unincorporatedcommunity(ordinary)).
fof(p2, axiom, (locatedin(ordinary, elliotcounty) & on(ordinary, kentuckyroute32))).
fof(p3, axiom, locatednorthwestof(ordinary, sandyhook)).
fof(extra1, axiom, (! [X] : ((on(X, kentuckyroute32) => ~(unincorporatedcommunity(X)))))).
