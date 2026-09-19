% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, producedby(luminaapv, chevrolet)).
fof(p2, axiom, (producedby(astro, chevrolet) & van(astro))).
fof(p3, axiom, ! [X] : ((((vehicle(X) & producedby(X, chevrolet)) & inthisbatch(X)) => (car(X) <~> van(X))))).
fof(extra1, axiom, (van(astro))).
