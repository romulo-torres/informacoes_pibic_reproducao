% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((fruit(X) & soldat(X, nicasmarket)) => shippedfrom(X, colombia)))).
fof(p2, axiom, ? [X] : (? [Y] : (((((((fruit(X) & soldin(X, newhaven)) & shippedfrom(X, mexico)) & ~((X = Y))) & fruit(Y)) & soldin(Y, newhaven)) & shippedfrom(Y, mexico))))).
fof(p3, axiom, ! [X] : (((fruit(X) & shippedfrom(X, colombia)) => ~(soldat(X, localfarmersmarket))))).
fof(p4, axiom, (fruit(avocado) & (soldat(avocado, localfarmersmarket) | soldat(avocado, nica_smarket)))).
fof(p5, axiom, ~((shippedfrom(avocado, colombia) <~> soldin(avocado, newhaven)))).
fof(extra1, axiom, ((~((soldat(avocado, localfarmersmarket) & shippedfrom(avocado, colombia))) => (~(soldat(avocado, localfarmersmarket)) & ~(soldin(avocado, newhaven)))))).
