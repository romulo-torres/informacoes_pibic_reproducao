% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, built(pierrederigauddevaudreuil, fortcarillon)).
fof(p2, axiom, locatedin(fortcarillon, newfrance)).
fof(p3, axiom, ~(locatedin(newfrance, europe))).
fof(extra1, axiom, (? [X] : ((built(pierrederigauddevaudreuil, X) & locatedin(X, newfrance))))).
