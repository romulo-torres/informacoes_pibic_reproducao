% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((sportscar(X) => loudcar(X)))).
fof(p2, axiom, ! [X] : ((loudcar(X) => ~(electriccar(X))))).
fof(p3, axiom, ! [X] : ((ferrari(X) => sportscar(X)))).
fof(p4, axiom, ! [X] : (((car(X) & madein(X, maranello)) => ferrari(X)))).
fof(p5, axiom, ((car(toyotaprius) & madein(toyotaprius, maranello)) | loudcar(toyotaprius))).
fof(extra1, axiom, (electriccar(toyotaprius))).
