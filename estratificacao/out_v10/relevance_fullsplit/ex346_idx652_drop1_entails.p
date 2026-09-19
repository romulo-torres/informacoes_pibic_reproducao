% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((cutman(X) => ((appearin(X, boxingmatch) | appearin(X, kickboxingmatch)) | appearin(X, mixedmartialartsmatchbout))))).
fof(p2, axiom, ! [X] : ((cutman(X) => ((handle(X, swelling) & handle(X, nosebleed)) & handle(X, laceration))))).
fof(p3, axiom, cutman(jack)).
fof(extra1, axiom, ~(treat(jack, physicaldamagetoafighter))).
