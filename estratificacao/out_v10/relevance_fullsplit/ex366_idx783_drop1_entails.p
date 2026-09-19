% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (! [Y] : ((((sciencefiction(X) & mythological(Y)) & creature(Y)) => ~(about(X, Y)))))).
fof(p2, axiom, (about(beastsofprey, shetani) & creature(shetani))).
fof(p3, axiom, mythological(shetani)).
fof(extra1, axiom, ~((mythological(shetani) <~> creature(shetani)))).
