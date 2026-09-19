% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((laptop(X) => computer(X)))).
fof(p2, axiom, ! [X] : ((computer(X) => canplaygameon(X)))).
fof(p3, axiom, ! [X] : ((phone(X) => ~(computer(X))))).
fof(extra1, axiom, ~(! [X] : ((laptop(X) => canplaygameon(X))))).
