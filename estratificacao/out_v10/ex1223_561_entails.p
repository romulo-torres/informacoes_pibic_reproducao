% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((bag(X) & hermes(X)) => ~(madein(X, italy))))).
fof(p2, axiom, ! [X] : (((bag(X) & birkin(X)) => hermes(X)))).
fof(p3, axiom, ! [X] : ((ferrari(X) => madein(X, italy)))).
fof(p4, axiom, ! [X] : (((car(X) & carry(X, ferrariv12engine)) => ferrrari(X)))).
fof(p5, axiom, ! [X] : (((car(X) & madein(X, maranello)) => carry(X, ferrariv12engine)))).
fof(p6, axiom, ~((ferrari(lamborghinisuv) & madein(lamborghinisuv, maranello)))).
fof(p7, axiom, ((bag(kelly) & hermes(kelly)) | ((bag(kelly) & car(kelly)) & carry(kelly, ferrariv12engine)))).
fof(extra1, axiom, ~(madein(lamborghinisuv, italy))).
