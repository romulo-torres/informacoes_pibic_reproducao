% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (team(goldenstatewarriors) & from(goldenstatewarriors, sanfrancisco))).
fof(p2, axiom, won(goldenstatewarriors, nbafinals)).
fof(p3, axiom, ! [X] : (((team(X) & attending(X, nbafinals)) => wonmanygames(X)))).
fof(p4, axiom, (team(bostonceltics) & lost(bostonceltics, nbafinals))).
fof(p5, axiom, ! [X] : (((team(X) & won(X, nbafinals)) => moreincome(X)))).
fof(p6, axiom, ! [X] : (((won(X, nbafinals) | lost(X, nbafinals)) => attending(X, nbafinals)))).
fof(extra1, axiom, (from(bostonceltics, sanfrancisco))).
