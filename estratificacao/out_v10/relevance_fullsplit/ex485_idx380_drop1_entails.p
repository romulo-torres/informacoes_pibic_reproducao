% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((volunteer(X) => (workregularly(X) <~> workasneeded(X))))).
fof(p2, axiom, ? [X] : ((volunteer(X) => trained(X)))).
fof(p3, axiom, ! [X] : ((volunteer(X) => (workingroup(X) | workindividually(X))))).
fof(p4, axiom, ! [X] : (((volunteer(X) & environmental(X)) => (contributeto(X, environmentalmanagement) | contributeto(X, environmentalconservation))))).
fof(p5, axiom, ? [X] : (((volunteer(X) & contributeto(X, naturaldisasterresponse)) => (workingroup(X) & workasneeded(X))))).
fof(extra1, axiom, ~(! [X] : (((volunteer(X) & contributeto(X, naturaldisasterresponse)) => receive(X, intangiblebenefit))))).
