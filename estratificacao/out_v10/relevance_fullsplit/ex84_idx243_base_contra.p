% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ((village(gasteren) & province(drenthe)) & in(gasteren, drenthe))).
fof(p2, axiom, (province(drenthe) & in(drenthe, netherlands))).
fof(p3, axiom, ! [X] : ((city(X) => ~(village(X))))).
fof(p4, axiom, ? [X] : (((population(X, num155) & village(X)) & in(X, drenthe)))).
fof(extra1, axiom, (city(gasteren))).
