% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (paintedby(monalisa, leonardodavinci) & portrait(monalisa))).
fof(p2, axiom, (scientist(leonardodavinci) & painter(leonardodavinci))).
fof(p3, axiom, ! [X] : ((painting(X) => ((((history(X) | portrait(X)) | animal(X)) | landscape(X)) | stilllife(X))))).
fof(extra1, axiom, ~(? [X] : (? [Y] : ((((painting(X) & theworldsbestknown(X)) & paintedby(X, Y)) & scientist(Y)))))).
