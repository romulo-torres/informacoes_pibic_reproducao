% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, neighbourhoodin(lawtonpark, seattle)).
fof(p2, axiom, ! [X] : ((residentof(X, lawtonpark) => usezipcode(X, num98199)))).
fof(p3, axiom, residentof(tom, lawtonpark)).
fof(p4, axiom, usezipcode(daniel, num98199)).
fof(extra1, axiom, (residentof(daniel, lawtonpark))).
