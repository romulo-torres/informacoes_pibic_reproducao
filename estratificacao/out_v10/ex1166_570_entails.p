% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((book(X) & writtenby(X, neilgaiman)) => ? [Y] : ((morethan(Y, num1000) & soldcopies(X, Y)))))).
fof(p2, axiom, ? [X] : (? [Y] : (((((((book(X) & win(X, hugoaward)) & writtenby(X, neilgaiman)) & ~((X = Y))) & book(Y)) & win(Y, hugoaward)) & writtenby(Y, neilgaiman))))).
fof(p3, axiom, ! [X] : (((book(X) & writtenby(X, tolkien)) => readby(X, tomas)))).
fof(p4, axiom, (readby(hamlet, tomas) <~> ? [Y] : ((morethan(Y, num1000) & soldcopies(hamlet, Y))))).
fof(p5, axiom, (? [Y] : ((morethan(Y, num1000) & soldcopies(hamlet, Y))) <~> writtenby(hamlet, neilgaiman))).
fof(extra1, axiom, ~(win(hamlet, hugoaward))).
