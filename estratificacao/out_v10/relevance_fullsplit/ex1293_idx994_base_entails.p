% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((animal(X) & need(X, largeterritory)) => travelfar(X)))).
fof(p2, axiom, ! [X] : ((eatalot(X) => need(X, largeterritory)))).
fof(p3, axiom, ! [X] : (((big(X) & animal(X)) => eatalot(X)))).
fof(p4, axiom, ! [X] : ((bear(X) => (big(X) & animal(X))))).
fof(p5, axiom, (big(larry) & animal(larry))).
fof(extra1, axiom, ~((~(bear(larry)) & ~(travelfar(larry))))).
