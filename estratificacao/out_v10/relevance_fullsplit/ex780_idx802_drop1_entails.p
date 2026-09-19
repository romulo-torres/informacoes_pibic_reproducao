% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((apply(X, schengenvisa) => provide(X, financialguarantees)))).
fof(p2, axiom, ! [X] : ((provide(X, financialguarantees) => request(X, documentsfrombank)))).
fof(p3, axiom, ! [X] : ((request(X, documentsfrombank) => ~(close(X, bankaccount))))).
fof(p4, axiom, close(philip, bankaccount)).
fof(extra1, axiom, ~((apply(philip, schengenvisa) & get(philip, schengenvisa)))).
