% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (painting(monalisa) & theworldsbestknown(monalisa))).
fof(p2, axiom, (paintedby(monalisa, leonardodavinci) & portrait(monalisa))).
fof(p3, axiom, (scientist(leonardodavinci) & painter(leonardodavinci))).
fof(p4, axiom, ! [X] : ((painting(X) => ((((history(X) | portrait(X)) | animal(X)) | landscape(X)) | stilllife(X))))).
fof(extra1, axiom, (? [X] : ((paintedby(X, leonardodavinci) & landscape(X))))).
