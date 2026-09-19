% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((attendinperson(X) => registered(X)))).
fof(p2, axiom, ! [X] : ((attend(X) => (attendinperson(X) <~> attendremotely(X))))).
fof(p3, axiom, ! [X] : (((attend(X) & fromchina(X)) => ~(attendremotely(X))))).
fof(p4, axiom, (attend(james) & ~(attendremotely(james)))).
fof(p5, axiom, (fromchina(jack) & attend(jack))).
fof(extra1, axiom, ~((attend(jack) & attendinperson(jack)))).
