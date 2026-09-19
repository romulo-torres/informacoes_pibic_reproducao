% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (novel(beastsofprey) => (fantasy(beastsofprey) | sciencefiction(beastsofprey)))).
fof(p2, axiom, (about(beastsofprey, shetani) & creature(shetani))).
fof(p3, axiom, mythological(shetani)).
fof(extra1, axiom, ~((mythological(shetani) <~> creature(shetani)))).
