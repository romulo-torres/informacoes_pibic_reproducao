% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((neocrepidoderacorpulenta(X) => (fleabeetle(X) | moth(X))))).
fof(p2, axiom, ! [X] : ((neocrepidoderacorpulenta(X) => in(X, chrysomelidaefamily)))).
fof(p3, axiom, ! [X] : ((in(X, chrysomelidaefamily) => ~(moth(X))))).
fof(p4, axiom, ? [X] : (neocrepidoderacorpulenta(X))).
fof(extra1, axiom, (! [X] : ((fleabeetle(X) => ~(in(X, chrysomelidaefamily)))))).
