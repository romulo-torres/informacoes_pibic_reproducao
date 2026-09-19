% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((rhosaelwydfc(X) => (footballclub(X) & welsh(X))))).
fof(p2, axiom, ! [X] : (((footballclub(X) & locatedin(X, ponciau)) <=> rhosaelwydfc(X)))).
fof(p3, axiom, ? [X] : ((locatedin(X, ponciau) & wonpremierdivisionduring(X, year2005monthjune)))).
fof(p4, axiom, ! [X] : ((wonpremierdivisionduring(X, year2009monthoctober) => promotedto(X, cymrualliance)))).
fof(p5, axiom, ! [X] : ((wonpremierdivisionduring(X, year2009monthoctober) <=> wonpremierdivisionduring(X, y2005monthjune)))).
fof(extra1, axiom, ~(? [X] : ((rhosaelwydfc(X) & promotedto(X, cymrualliance))))).
