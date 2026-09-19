% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (! [Y] : ((((((laligasoccerteam(X) & laligasoccerteam(Y)) & ~(morepoints(X, Y))) & ~(morepoints(Y, X))) & morepointsingamebetween(X, Y)) => rankhigherthan(X, Y))))).
fof(p2, axiom, (laligasoccerteam(realmadrid) & laligasoccerteam(barcelona))).
fof(p3, axiom, morepoints(realmadrid, barcelona)).
fof(p4, axiom, (~(morepointsingamebetween(realmadrid, barcelona)) & ~(morepointsingamebetween(barcelona, realmadrid)))).
fof(extra1, axiom, (rankhigherthan(realmadrid, barcelona))).
