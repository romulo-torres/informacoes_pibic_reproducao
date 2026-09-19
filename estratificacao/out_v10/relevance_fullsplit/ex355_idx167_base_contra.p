% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((musician(X) => have(X, busylife)))).
fof(p2, axiom, (musician(singhkaur) & famous(singhkaur))).
fof(p3, axiom, ! [X] : (((musician(X) & ~(famous(X))) => ~(makealotofmoney(X))))).
fof(p4, axiom, ? [X] : ((musician(X) & (singer(X) | writer(X))))).
fof(extra1, axiom, (makealotofmoney(singhkaur))).
