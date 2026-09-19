% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((computer(X) => canplaygameon(X)))).
fof(p2, axiom, ! [X] : ((phone(X) => ~(computer(X))))).
fof(extra1, axiom, (! [X] : ((laptop(X) => canplaygameon(X))))).
