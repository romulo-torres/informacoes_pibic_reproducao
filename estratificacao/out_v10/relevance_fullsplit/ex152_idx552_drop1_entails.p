% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (producedby(astro, chevrolet) & van(astro))).
fof(p2, axiom, ! [X] : ((((vehicle(X) & producedby(X, chevrolet)) & inthisbatch(X)) => (car(X) <~> van(X))))).
fof(extra1, axiom, ~(van(astro))).
