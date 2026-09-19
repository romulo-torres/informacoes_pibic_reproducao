% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ((((british(michael) & physician(michael)) & journalist(michael)) & author(michael)) & broadcaster(michael))).
fof(p2, axiom, (magazine(worldmedicine) & editedby(worldmedicine, michael))).
fof(p3, axiom, (bornin(michael, yorkshire) & ? [X] : ((sonof(michael, X) & generalpractitioner(X))))).
fof(extra1, axiom, ~(~(magazine(worldmedicine)))).
