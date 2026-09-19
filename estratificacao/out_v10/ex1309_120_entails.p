% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((cancontrol(X, breath) => functionalbrainstem(X)))).
fof(p2, axiom, ! [X] : (((human(X) & canswim(X)) => cancontrol(X, breath)))).
fof(p3, axiom, ! [X] : ((human(X) => (canswim(X) | canwalk(X))))).
fof(p4, axiom, ! [X] : (((human(X) & canwalk(X)) => canstandontheground(X, themselves)))).
fof(p5, axiom, ! [X] : (((human(X) & functionalbrainstem(X)) => cancontrol(X, balance)))).
fof(p6, axiom, ! [X] : (((human(X) & canstandontheground(X, themselves)) => functionallegmuscle(X)))).
fof(p7, axiom, (human(george) & human(archie))).
fof(p8, axiom, (cancontrol(george, balance) & canswim(george))).
fof(p9, axiom, ~((canwalk(archie) <~> functionalbrainstem(x)))).
fof(extra1, axiom, ~((~(cancontrol(archie, balance)) & ~(functionallegmuscle(x))))).
