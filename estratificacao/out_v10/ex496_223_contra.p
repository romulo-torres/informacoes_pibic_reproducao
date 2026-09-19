% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, country(indonesia)).
fof(p2, axiom, ! [X] : (? [Y] : ((((in(indonesia) & prosecutor(X)) & specialcrime(Y)) => investigatepersonally(X, Y))))).
fof(p3, axiom, crime(corruption)).
fof(p4, axiom, ! [X] : (! [Y] : (! [Z] : ((((crime(Y) & policecompleteinvestigation(Y)) & prosecutor(X)) => (evidence(Z) & handedto(Z, X))))))).
fof(p5, axiom, ! [X] : ((evidence(X) & (satisfactory(X) <~> unsatisfactory(X))))).
fof(p6, axiom, ! [X] : (! [Y] : (((((evidence(Y) & prosecutor(X)) & handedto(X)) & satisfactory(Y)) => prosecuteinappropriatecourt(X, theoffender))))).
fof(extra1, axiom, (! [X] : (! [Y] : ((((crime(Y) & policecompleteinvestigation(Y)) & prosecutor(X)) => investigatepersonally(X, Y)))))).
