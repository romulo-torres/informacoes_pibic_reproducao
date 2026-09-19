% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (musician(singhkaur) & famous(singhkaur))).
fof(p2, axiom, ! [X] : (((musician(X) & ~(famous(X))) => ~(makealotofmoney(X))))).
fof(p3, axiom, ? [X] : ((musician(X) & (singer(X) | writer(X))))).
fof(extra1, axiom, ~(have(singhkaur, busylife))).
