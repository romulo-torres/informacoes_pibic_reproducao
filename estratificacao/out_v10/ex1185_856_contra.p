% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : ((latenightperson(X) & earlymorningperson(X)))).
fof(p2, axiom, ! [X] : ((earlymorningperson(X) => have(X, earlymorninghabit)))).
fof(p3, axiom, ! [X] : ((have(X, earlymorninghabit) => getupearly(X)))).
fof(p4, axiom, ! [X] : ((getupearly(X) => catchthesunrise(X)))).
fof(p5, axiom, ~(catchthesunrise(james))).
fof(extra1, axiom, ((latenightperson(james) & earlymorningperson(james)))).
