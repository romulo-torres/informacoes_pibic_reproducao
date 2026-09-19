% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((day(X) => ~(prefer(olivia, warmtemperature, X))))).
fof(p2, axiom, ! [X] : ((sleep(olivia, X) => prefer(olivia, cooltemperature, X)))).
fof(p3, axiom, ! [X] : ((night(X) => sleep(olivia, X)))).
fof(p4, axiom, ! [X] : ((day(X) => work(olivia, X)))).
fof(p5, axiom, (work(olivia) <~> sleep(olivia))).
fof(p6, axiom, ! [X] : ((day(X) <~> night(X)))).
fof(p7, axiom, ! [X] : ((prefer(olivia, warmtemperature, X) <~> prefer(olivia, cooltemperature, X)))).
fof(extra1, axiom, ~(! [X] : (prefer(olivia, cooltemperature, X)))).
