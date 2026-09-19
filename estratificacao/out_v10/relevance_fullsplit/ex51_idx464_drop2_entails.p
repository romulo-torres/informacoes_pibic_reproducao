% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (czech(miroslavfiedler) & mathematician(miroslavfiedler))).
fof(p2, axiom, honoredby(miroslavfiedler, fiedlereigenvalue)).
fof(p3, axiom, thesecondsmallesteigenvalueof(fiedlereigenvalue, thegraphlaplacian)).
fof(extra1, axiom, ~(? [X] : ((thesecondsmallesteigenvalueof(X, thegraphlaplacian) & honoredby(miroslavfiedler, X))))).
