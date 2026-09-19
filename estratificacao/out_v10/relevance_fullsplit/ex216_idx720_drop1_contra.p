% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (born(herodicus, selymbia) & city(selymbia))).
fof(p2, axiom, (colony(selymbia, megara) & citystate(megara))).
fof(p3, axiom, tutor(herodicus, hippocrates)).
fof(p4, axiom, recommend(herodicus, massages)).
fof(p5, axiom, ? [X] : (? [Y] : (((((((theory(X) & from(X, herodicus)) & foundationof(X, sportsmedicine)) & ~((X = Y))) & theory(Y)) & from(Y, herodicus)) & foundationof(Y, sportsmedicine))))).
fof(extra1, axiom, (~(recommend(herodicus, massages)))).
