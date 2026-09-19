% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((attend(X) => (attendinperson(X) <~> attendremotely(X))))).
fof(p2, axiom, ! [X] : (((attend(X) & fromchina(X)) => ~(attendremotely(X))))).
fof(p3, axiom, (attend(james) & ~(attendremotely(james)))).
fof(p4, axiom, (fromchina(jack) & attend(jack))).
fof(extra1, axiom, ((attend(james) & ~(attendinperson(james))))).
