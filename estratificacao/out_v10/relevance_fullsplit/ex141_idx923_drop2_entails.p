% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (((american(quincymcduffie) & professional(quincymcduffie)) & widereciever(quincymcduffie)) & playsin(quincymcduffie, cfl))).
fof(p2, axiom, (? [X] : (? [Y] : ((football(X) & cancatch(quincymcduffie, X)))) & (~((x = y)) & (football(y) & cancatch(quincymcduffie, y))))).
fof(p3, axiom, ! [X] : ((goodwidereceiver(X) => professional(X)))).
fof(p4, axiom, ! [X] : ((goodwidereceiver(X) => (cancatchwith(X, lefthand) & cancatchwith(X, righthand))))).
fof(p5, axiom, ! [X] : ((football(X) => ball(X)))).
fof(extra1, axiom, ~(goodwidereceiver(quincymcduffie))).
