% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ? [X] : ((((bric(X) & ~((X = china))) & bric(china)) & emerging(chinaeconomy)))).
fof(p2, axiom, ! [X] : ((from(X, china) => from(X, bric)))).
fof(p3, axiom, (bric(india) & emerging(indiaeconomy))).
fof(p4, axiom, ! [X] : ((from(X, india) => from(X, bric)))).
fof(p5, axiom, ! [X] : ((from(X, china) => chinese(X)))).
fof(p6, axiom, ! [X] : ((from(X, india) => indian(X)))).
fof(p7, axiom, ? [X] : (from(X, india))).
fof(extra1, axiom, ~(? [X] : ((indianpeople(X) & from(X, countryofbrics))))).
