% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, renamedas(fortcarillon, fortticonderoga)).
fof(p2, axiom, locatedin(fortcarillon, newfrance)).
fof(p3, axiom, ~(locatedin(newfrance, europe))).
fof(extra1, axiom, ~(? [X] : ((built(pierrederigauddevaudreuil, X) & locatedin(X, newfrance))))).
