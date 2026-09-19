% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((cat(X) => ~(dog(X))))).
fof(p2, axiom, ! [X] : ((bengaltiger(X) => tiger(X)))).
fof(p3, axiom, ! [X] : ((husky(X) => dog(X)))).
fof(p4, axiom, (bengaltiger(fido) <~> cat(fido))).
fof(extra1, axiom, ((~(dog(fido)) & ~(husky(fido))))).
