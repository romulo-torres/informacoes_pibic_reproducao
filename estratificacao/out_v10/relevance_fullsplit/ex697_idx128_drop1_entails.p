% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((snake(X) => reptile(X)))).
fof(extra1, axiom, ~(? [X] : ((snake(X) & have(X, fur))))).
