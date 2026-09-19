% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((dog(X) => ~(onroof(X))))).
fof(p2, axiom, ! [X] : (? [Y] : (((dog(X) & onroof(X)) => gowrong(Y))))).
fof(extra1, axiom, ~(? [X] : (gowrong(X)))).
