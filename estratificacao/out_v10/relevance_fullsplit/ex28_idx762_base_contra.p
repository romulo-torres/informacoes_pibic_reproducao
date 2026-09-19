% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ((youngadultfantasy(thickastheives) & novel(thickastheives)) & writtenby(thickastheives, meganwhalenturner))).
fof(p2, axiom, publishedby(thickastheives, greenwillowbooks)).
fof(p3, axiom, ! [X] : (! [Y] : (! [Z] : (((writtenby(X, Y) & publishedby(X, Z)) => workedwith(Y, Z)))))).
fof(p4, axiom, (fictional(medeempire) & setin(thickastheives, medeempire))).
fof(p5, axiom, ? [X] : (? [Y] : ((((country(X) & near(X, medeempire)) & plotstoswallowup(medeempire, X)) & ((~((X = Y)) & near(Y, medeempire)) & plotstoswallowup(medeempire, Y)))))).
fof(p6, axiom, (((country(attolia) & near(attolia, medeempire)) & country(sounis)) & near(sounis, medeempire))).
fof(p7, axiom, (soldas(thickastheives, hardcover) & soldas(thickastheives, softcover))).
fof(extra1, axiom, (~(workedwith(megan, greenwillowbooks)))).
