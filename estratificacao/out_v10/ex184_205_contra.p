% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((ownedby(X, company) => connectedto(X, googlehome)))).
fof(p2, axiom, ! [X] : ((ownedby(X, employee) => connectedto(X, companywifi)))).
fof(p3, axiom, ! [X] : ((connectedto(X, googlehome) => controlledby(X, managers)))).
fof(p4, axiom, ! [X] : ((connectedto(X, companywifi) => easytooperate(X)))).
fof(p5, axiom, ownedby(modelxx, employee)).
fof(extra1, axiom, (controlledby(modelxx, managers))).
