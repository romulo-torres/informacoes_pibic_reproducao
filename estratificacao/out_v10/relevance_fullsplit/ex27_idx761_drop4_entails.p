% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ((youngadultfantasy(thickastheives) & novel(thickastheives)) & writtenby(thickastheives, meganwhalenturner))).
fof(p2, axiom, publishedby(thickastheives, greenwillowbooks)).
fof(p3, axiom, ! [X] : (! [Y] : (! [Z] : (((writtenby(X, Y) & publishedby(X, Z)) => workedwith(Y, Z)))))).
fof(p4, axiom, ? [X] : (? [Y] : ((((country(X) & near(X, medeempire)) & plotstoswallowup(medeempire, X)) & ((~((X = Y)) & near(Y, medeempire)) & plotstoswallowup(medeempire, Y)))))).
fof(p5, axiom, (((country(attolia) & near(attolia, medeempire)) & country(sounis)) & near(sounis, medeempire))).
fof(p6, axiom, (soldas(thickastheives, hardcover) & soldas(thickastheives, softcover))).
fof(extra1, axiom, ~(~(setin(thickastheives, medeempire)))).
