% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (! [Y] : ((((((soccerteam(X) & soccerteam(Y)) & samescore(X, Y)) & during(regulartime)) & during(extratime)) => playpenalty(X, Y))))).
fof(p2, axiom, (((soccerteam(realmadrid) & soccerteam(atleticomadrid)) & samescore(realmadrid, atleticomadrid)) & during(regulartime))).
fof(p3, axiom, (((soccerteam(realmadrid) & soccerteam(atleticomadrid)) & samescore(realmadrid, atleticomadrid)) & during(extratime))).
fof(extra1, axiom, (~(playpenalty(realmadrid, atleticomadrid)))).
