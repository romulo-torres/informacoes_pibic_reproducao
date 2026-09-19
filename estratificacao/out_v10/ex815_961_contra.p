% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((cancer(X) => have(X, mutation)))).
fof(p2, axiom, ! [X] : ((have(X, mutation) => ~(canbetreatedathome(X))))).
fof(p3, axiom, ! [X] : ((colorectalcancer(X) => cancer(X)))).
fof(p4, axiom, ! [X] : ((cold(X) => canbetreatedathome(X)))).
fof(p5, axiom, ~((cold(arthritis) <~> have(arthritis, mutation)))).
fof(extra1, axiom, ((~(colorectalcancer(arthritis)) => have(arthritis, mutation)))).
