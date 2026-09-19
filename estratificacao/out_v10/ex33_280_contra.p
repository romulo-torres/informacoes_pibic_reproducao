% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, drainagebasinof(crotonriverwatershed, crotonriver)).
fof(p2, axiom, in(crotonriver, southwesternnewyork)).
fof(p3, axiom, ! [X] : (((water(X) & in(X, crotonriverwatershed)) => flowsto(X, bronx)))).
fof(p4, axiom, in(bronx, newyork)).
fof(extra1, axiom, (in(crotonriverwatershed, bronx))).
