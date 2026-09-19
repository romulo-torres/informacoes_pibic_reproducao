% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((eatalot(X) => need(X, largeterritory)))).
fof(p2, axiom, ! [X] : (((big(X) & animal(X)) => eatalot(X)))).
fof(p3, axiom, ! [X] : ((bear(X) => (big(X) & animal(X))))).
fof(p4, axiom, (big(larry) & animal(larry))).
fof(extra1, axiom, (((travelfar(larry) <~> need(larry, largeterritory)) => bear(larry)))).
