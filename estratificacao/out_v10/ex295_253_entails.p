% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ((american(maggiefriedman) & screenwriter(maggiefriedman)) & producer(maggiefriedman))).
fof(p2, axiom, ((showrunnerof(maggiefriedman, witchesofeastend) & executiveproducerof(maggiefriedman, witchesofeastend)) & lifetimetelevisionseries(maggiefriedman))).
fof(p3, axiom, (fantasydrama(witchesofeastend) & series(witchesofeastend))).
fof(p4, axiom, (produces(maggiefriedman, eastwick) & develops(maggiefriedman, eastwick))).
fof(p5, axiom, (series(eastwick) & airedon(eastwick, abc))).
fof(extra1, axiom, ~(? [X] : (? [Y] : ((((series(X) & airedon(X, abc)) & develops(Y, X)) & showrunnerof(Y, witchesofeastend)))))).
