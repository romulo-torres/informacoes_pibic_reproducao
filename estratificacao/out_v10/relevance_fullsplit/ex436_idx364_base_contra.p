% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : (send(guam, athlete, calgarywinterolympics))).
fof(p2, axiom, ! [X] : (((athlete(X) & sendto(guam, X, calgarywinterolympics)) => participatedin(X, winterolympics, year1988)))).
fof(p3, axiom, ! [X] : (! [Y] : ((((athlete(X) & from(X, guam)) & participatedin(X, winterolympics, Y)) => (X = juddbankert))))).
fof(extra1, axiom, (? [X] : (participatedin(guam, summerolympics, X)))).
