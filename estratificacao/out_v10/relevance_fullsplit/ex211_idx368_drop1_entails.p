% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, wordsetter(michael)).
fof(p2, axiom, (magazine(worldmedicine) & editedby(worldmedicine, michael))).
fof(p3, axiom, (bornin(michael, yorkshire) & ? [X] : ((sonof(michael, X) & generalpractitioner(X))))).
fof(extra1, axiom, ~(! [X] : ((journalist(X) => ~(bornin(X, yorkshire)))))).
