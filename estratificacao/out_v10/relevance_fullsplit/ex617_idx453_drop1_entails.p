% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((sleep(olivia, X) => prefer(olivia, cooltemperature, X)))).
fof(p2, axiom, ! [X] : ((night(X) => sleep(olivia, X)))).
fof(p3, axiom, ! [X] : ((day(X) => work(olivia, X)))).
fof(p4, axiom, (work(olivia) <~> sleep(olivia))).
fof(p5, axiom, ! [X] : ((day(X) <~> night(X)))).
fof(p6, axiom, ! [X] : ((prefer(olivia, warmtemperature, X) <~> prefer(olivia, cooltemperature, X)))).
fof(extra1, axiom, ~(! [X] : (prefer(olivia, cooltemperature, X)))).
