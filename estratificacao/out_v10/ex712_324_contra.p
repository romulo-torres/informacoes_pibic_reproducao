% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((~(admit(X, mistake)) => ~(goodteacher(X))))).
fof(p2, axiom, ? [X] : (? [Y] : (((((wellinformed(X) & wellinformed(Y)) & ~(admit(X, mistake))) & ~(admit(Y, mistake))) & ~((X = Y)))))).
fof(extra1, axiom, (? [X] : (? [Y] : (((((goodteacher(X) & goodteacher(Y)) & ~(wellinformed(X))) & ~(wellinformed(Y))) & ~((X = Y))))))).
