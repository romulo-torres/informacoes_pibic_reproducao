% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((juveniledelinquent(X) => commited(X, crime)))).
fof(p2, axiom, ? [X] : (? [Y] : (((((juveniledelinquent(X) & juveniledelinquent(Y)) & productof(X, brokenhome)) & productof(Y, brokenhome)) & ~((X = Y)))))).
fof(extra1, axiom, ~(? [X] : (? [Y] : (((((commited(X, crime) & commited(Y, crime)) & productof(X, brokenhome)) & productof(Y, brokenhome)) & ~((X = Y))))))).
