% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((tiger(X) => cat(X)))).
fof(p2, axiom, ! [X] : ((cat(X) => ~(dog(X))))).
fof(p3, axiom, ! [X] : ((bengaltiger(X) => tiger(X)))).
fof(p4, axiom, ! [X] : ((husky(X) => dog(X)))).
fof(p5, axiom, (bengaltiger(fido) <~> cat(fido))).
fof(extra1, axiom, ~((~(dog(fido)) & ~(husky(fido))))).
