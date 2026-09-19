% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (novel(beastsofprey) => (fantasy(beastsofprey) | sciencefiction(beastsofprey)))).
fof(p2, axiom, ! [X] : (! [Y] : ((((sciencefiction(X) & mythological(Y)) & creature(Y)) => ~(about(X, Y)))))).
fof(p3, axiom, (about(beastsofprey, shetani) & creature(shetani))).
fof(p4, axiom, mythological(shetani)).
fof(extra1, axiom, ~((~(sciencefiction(beastsofprey)) & novel(beastsofprey)))).
