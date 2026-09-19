% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((ownedby(X, company) => connectedto(X, googlehome)))).
fof(p2, axiom, ! [X] : ((connectedto(X, googlehome) => controlledby(X, managers)))).
fof(p3, axiom, ! [X] : ((connectedto(X, companywifi) => easytooperate(X)))).
fof(p4, axiom, ownedby(modelxx, employee)).
fof(extra1, axiom, ~(easytooperate(modelxx))).
