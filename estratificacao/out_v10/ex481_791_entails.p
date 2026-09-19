% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((gobytrain(X) => ~(losetime(X))))).
fof(p2, axiom, ! [X] : (((gobycar(X) & meet(X, trafficjam)) => losetime(X)))).
fof(p3, axiom, ! [X] : ((losetime(X) => lateforwork(X)))).
fof(p4, axiom, (fromandto(newhaven, newyork) & (gobytrain(mary) <~> gobycar(mary)))).
fof(p5, axiom, lateforwork(mary)).
fof(extra1, axiom, ~(meet(mary, trafficjam))).
