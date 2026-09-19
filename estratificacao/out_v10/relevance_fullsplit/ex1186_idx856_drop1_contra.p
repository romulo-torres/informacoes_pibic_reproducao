% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((earlymorningperson(X) => have(X, earlymorninghabit)))).
fof(p2, axiom, ! [X] : ((have(X, earlymorninghabit) => getupearly(X)))).
fof(p3, axiom, ! [X] : ((getupearly(X) => catchthesunrise(X)))).
fof(p4, axiom, ~(catchthesunrise(james))).
fof(extra1, axiom, ((earlymorningperson(james) => latenightperson(james)))).
