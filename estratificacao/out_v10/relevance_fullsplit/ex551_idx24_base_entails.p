% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (! [Y] : ((((laligasoccerteam(X) & laligasoccerteam(Y)) & morepoints(X, Y)) => rankhigherthan(X, Y))))).
fof(p2, axiom, ! [X] : (! [Y] : ((((((laligasoccerteam(X) & laligasoccerteam(Y)) & ~(morepoints(X, Y))) & ~(morepoints(Y, X))) & morepointsingamebetween(X, Y)) => rankhigherthan(X, Y))))).
fof(p3, axiom, (laligasoccerteam(realmadrid) & laligasoccerteam(barcelona))).
fof(p4, axiom, morepoints(realmadrid, barcelona)).
fof(p5, axiom, (~(morepointsingamebetween(realmadrid, barcelona)) & ~(morepointsingamebetween(barcelona, realmadrid)))).
fof(extra1, axiom, ~(rankhigherthan(barcelona, realmadrid))).
