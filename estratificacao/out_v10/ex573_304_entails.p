% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ? [X] : (? [Y] : (? [Y] : (? [W] : (((((((((((game(X) & stagenumber(X, num3)) & stage(Y)) & stage(z)) & stage(W)) & ~((Y = z))) & ~((z = W))) & ~((Y = W))) & red(Y)) & yellow(z)) & green(W))))))).
fof(p2, axiom, ! [X] : ((player(X) => startred(X)))).
fof(p3, axiom, ! [X] : (((player(X) & ~(reachyellow(X))) => ~(reachgreen(X))))).
fof(p4, axiom, ! [X] : (((player(X) & startred(X)) => reachyellow(X)))).
fof(p5, axiom, ! [X] : ((((player(X) & startred(X)) & ~(reachyellow(X))) => ~(reachgreen(X))))).
fof(extra1, axiom, ~(? [X] : ((player(X) & redtoyellow(X))))).
