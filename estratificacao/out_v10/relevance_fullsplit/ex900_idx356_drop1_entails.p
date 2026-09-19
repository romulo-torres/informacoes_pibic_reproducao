% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((loudcar(X) => ~(electriccar(X))))).
fof(p2, axiom, ! [X] : ((ferrari(X) => sportscar(X)))).
fof(p3, axiom, ! [X] : (((car(X) & madein(X, maranello)) => ferrari(X)))).
fof(p4, axiom, ((car(toyotaprius) & madein(toyotaprius, maranello)) | loudcar(toyotaprius))).
fof(extra1, axiom, ~(electriccar(toyotaprius))).
