% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, gui(tora)).
fof(p2, axiom, ! [X] : ((gui(X) => software(X)))).
fof(p3, axiom, ! [X] : ((software(X) => (free(X) <~> paid(X))))).
fof(p4, axiom, undergnulicense(tora)).
fof(extra1, axiom, ((paid(tora) & software(tora)))).
