% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, won(goldenstatewarriors, nbafinals)).
fof(p2, axiom, ! [X] : (((team(X) & attending(X, nbafinals)) => wonmanygames(X)))).
fof(p3, axiom, (team(bostonceltics) & lost(bostonceltics, nbafinals))).
fof(p4, axiom, ! [X] : (((team(X) & won(X, nbafinals)) => moreincome(X)))).
fof(p5, axiom, ! [X] : (((won(X, nbafinals) | lost(X, nbafinals)) => attending(X, nbafinals)))).
fof(extra1, axiom, ~(moreincome(goldenstatewarriors))).
