% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((philateliclit(X) => (((((stamp(X) | periodical(X)) | auction(X)) | book(X)) | bibliography(X)) | background(X))))).
fof(p2, axiom, ~(stamp(mort))).
fof(p3, axiom, philateliclit(mort)).
fof(extra1, axiom, ~(background(mort))).
