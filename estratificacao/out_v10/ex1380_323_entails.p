% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((entitledto(X, nationalsocialinsurancecoverage) => canhavepartiallycovered(X, medicalbills)))).
fof(p2, axiom, ! [X] : ((prcnational(X) => entitledto(X, nationalsocialinsurancecoverage)))).
fof(p3, axiom, ! [X] : ((in(X, franco_chinadiplomaticconference) => (prcnational(X) <~> frenchnational(X))))).
fof(p4, axiom, ! [X] : ((frenchnational(X) => citizenof(X, europeanunion)))).
fof(p5, axiom, ! [X] : ((spanishnational(X) => citizenof(X, europeanunion)))).
fof(p6, axiom, ! [X] : ((northkoreannational(X) => ~(citizenof(X, europeanunion))))).
fof(p7, axiom, in(mei, franco_chinadiplomaticconference)).
fof(p8, axiom, ~((northkoreannational(mei) <~> canhavepartiallycovered(mei, medicalbills)))).
fof(extra1, axiom, ~(((northkoreannational(mei) <~> spanishnational(mei)) => ~((frenchnational(mei) <~> european(mei)))))).
