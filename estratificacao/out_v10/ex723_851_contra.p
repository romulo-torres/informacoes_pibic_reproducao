% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((surprise(X) => (fun(X) <~> dreadful(X))))).
fof(p2, axiom, ! [X] : ((scare(X) => surprise(X)))).
fof(extra1, axiom, (! [X] : ((scare(X) => fun(X))))).
