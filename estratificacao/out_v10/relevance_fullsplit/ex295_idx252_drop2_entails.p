% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ((american(maggiefriedman) & screenwriter(maggiefriedman)) & producer(maggiefriedman))).
fof(p2, axiom, (fantasydrama(witchesofeastend) & series(witchesofeastend))).
fof(p3, axiom, (produces(maggiefriedman, eastwick) & develops(maggiefriedman, eastwick))).
fof(p4, axiom, (series(eastwick) & airedon(eastwick, abc))).
fof(extra1, axiom, ~(? [X] : (? [Y] : ((((series(X) & airedon(X, abc)) & develops(Y, X)) & showrunnerof(Y, witchesofeastend)))))).
