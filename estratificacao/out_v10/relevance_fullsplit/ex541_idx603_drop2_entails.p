% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [W] : (! [X] : (! [Y] : (! [Z] : (((((((soccerteam(X) & soccerteam(Y)) & numberofgoalscored(X, Z)) & numberofgoalscored(Y, W)) & (Y = W)) & during(regulartime)) => playextra(X, Y))))))).
fof(p2, axiom, (((soccerteam(realmadrid) & soccerteam(atleticomadrid)) & samescore(realmadrid, atleticomadrid)) & during(regulartime))).
fof(p3, axiom, (((soccerteam(realmadrid) & soccerteam(atleticomadrid)) & samescore(realmadrid, atleticomadrid)) & during(extratime))).
fof(extra1, axiom, ~(~(playpenalty(realmadrid, atleticomadrid)))).
