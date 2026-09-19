% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ((play(peter, piano) & play(peter, violin)) & play(peter, saxophone))).
fof(p2, axiom, playin(peter, piano, concert)).
fof(p3, axiom, ? [X] : (? [Y] : ((playin(peter, X, concert) & playin(oliver, Y, concert))))).
fof(p4, axiom, ! [X] : ((playin(oliver, X, concert) => ~(playin(peter, y, concert))))).
fof(extra1, axiom, (goodatplaying(peter, piano))).
