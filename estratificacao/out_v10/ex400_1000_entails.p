% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, indiepop(phoenix)).
fof(p2, axiom, (band(phoenix) & from(phoenix, france))).
fof(p3, axiom, ! [X] : (? [Y] : (((((band(X) & from(X, france)) & write(X, Y)) & song(Y)) => (infrench(Y) <~> inenglish(Y)))))).
fof(p4, axiom, ! [X] : ((indiepop(X) => (~(poprock(X)) & ~(synthpop(X)))))).
fof(p5, axiom, ! [X] : (((song(X) & by(phoenix, X)) => ~(infrench(X))))).
fof(extra1, axiom, ~(poprock(phoenix))).
