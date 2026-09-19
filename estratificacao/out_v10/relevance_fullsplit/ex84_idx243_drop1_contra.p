% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (province(drenthe) & in(drenthe, netherlands))).
fof(p2, axiom, ! [X] : ((city(X) => ~(village(X))))).
fof(p3, axiom, ? [X] : (((population(X, num155) & village(X)) & in(X, drenthe)))).
fof(extra1, axiom, (city(gasteren))).
