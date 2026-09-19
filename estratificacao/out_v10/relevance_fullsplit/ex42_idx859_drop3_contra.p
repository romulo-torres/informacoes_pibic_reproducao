% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((elephantopus(X) => (genus(X, perennialplants) & belongto(X, daisyfamily))))).
fof(p2, axiom, ? [X] : (? [Y] : (? [Z] : (((((((((elephantopus(X) & in(X, africa)) & ~((X = Y))) & elephantopus(Y)) & in(Y, southernasia)) & ~((X = Z))) & ~((Y = Z))) & elephantopus(Z)) & in(Z, australia)))))).
fof(p3, axiom, ! [X] : ((elephantopusscaber(X) => traditionalmedicine(X)))).
fof(extra1, axiom, (! [X] : ((elephantopus(X) => ~(nativeto(X, southeasternunitedstates)))))).
