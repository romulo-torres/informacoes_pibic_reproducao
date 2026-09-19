% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : (? [Y] : ((((car(X) & car(Y)) & (X = Y)) & owns(adam, X))))).
fof(p2, axiom, ? [X] : ((car(X) & favorite(adam, X)))).
fof(p3, axiom, ! [X] : ((((car(X) & owns(adam, X)) & favorite(adam, X)) => european(X)))).
fof(p4, axiom, ! [X] : ((((car(X) & owns(adam, X)) & favorite(adam, X)) => broke(adam, X)))).
fof(extra1, axiom, (? [X] : ((japanese(X) & owns(adam, X))))).
