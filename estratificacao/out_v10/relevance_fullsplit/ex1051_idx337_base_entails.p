% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((knows(dan, X) & imaginativeprocess(X)) => resultof(X, creativeprocess)))).
fof(p2, axiom, ! [X] : (((knows(dan, X) & sciencefiction(X)) => imaginativeprocess(X)))).
fof(p3, axiom, ! [X] : ((knows(dan, X) => (sciencefiction(X) <~> realisticfiction(X))))).
fof(p4, axiom, ! [X] : (((knows(dan, X) & fact(X)) => ~(provedtobe(X, false))))).
fof(p5, axiom, ((knows(dan, dune) & sciencefiction(dune)) | provedtobe(dune, false))).
fof(extra1, axiom, ~((knows(dan, dune) & (resultof(dune, creativeprocess) <~> sciencefiction(dune))))).
