% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((philateliclit(X) => (((((stamp(X) | periodical(X)) | auction(X)) | book(X)) | bibliography(X)) | background(X))))).
fof(p2, axiom, ~(stamp(mort))).
fof(p3, axiom, ~((((periodical(mort) | auction(mort)) | bibliography(mort)) | background(mort)))).
fof(p4, axiom, philateliclit(mort)).
fof(extra1, axiom, (background(mort))).
