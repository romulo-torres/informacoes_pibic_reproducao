% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, horse(detroitcity)).
fof(p2, axiom, ? [X] : ((horse(X) & racehorse(X)))).
fof(p3, axiom, ! [X] : ((((horse(X) & inrace(X)) & falls(X)) => poseriskto(X, rider)))).
fof(p4, axiom, (inrace(detroitcity) & fall(detroitcity))).
fof(p5, axiom, ! [X] : (((horse(X) & inrace(X)) => racehorse(X)))).
fof(extra1, axiom, ~(racehorse(detroitcity))).
