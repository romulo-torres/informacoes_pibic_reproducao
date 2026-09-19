% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (play(vicdicara, guitar) & play(vicdicara, bass))).
fof(p2, axiom, ! [X] : ((music(vicdicara, X) => ~((X = punk))))).
fof(p3, axiom, band(vicdicara, insideout)).
fof(extra1, axiom, (? [X] : ((band(X, insideout) & play(X, bass))))).
