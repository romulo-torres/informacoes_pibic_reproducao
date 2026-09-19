% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((buildings(X) & in(X, newhaven)) => ~(higherthan(X, num400))))).
fof(p2, axiom, ! [X] : (((buildings(X) & managedby(X, yalehousing)) => in(X, newhaven)))).
fof(p3, axiom, ! [X] : ((((buildings(X) & skyscraper(X)) & in(X, manhattan)) => higherthan(X, num400)))).
fof(p4, axiom, ! [X] : (((buildings(X) & ownedby(X, bloomberg)) => (skyscraper(X) & in(X, manhattan))))).
fof(p5, axiom, ! [X] : (((buildings(X) & haslogo(X, bloomberg)) => ownedby(X, bloomberg)))).
fof(p6, axiom, ((buildings(towera) & ~(innewhaven(towera))) & ~(manhattanskyscraper(towera)))).
fof(p7, axiom, (((buildings(towerb) & haslogo(towerb, bloomberg)) & skyscraper(towerb)) & in(towerb, manhattan))).
fof(extra1, axiom, ~(higherthan(towera, num400))).
