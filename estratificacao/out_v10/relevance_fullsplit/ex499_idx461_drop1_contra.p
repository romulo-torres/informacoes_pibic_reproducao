% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : ((horse(X) & racehorse(X)))).
fof(p2, axiom, ! [X] : ((((horse(X) & inrace(X)) & falls(X)) => poseriskto(X, rider)))).
fof(p3, axiom, (inrace(detroitcity) & fall(detroitcity))).
fof(p4, axiom, ! [X] : (((horse(X) & inrace(X)) => racehorse(X)))).
fof(extra1, axiom, (racehorse(detroitcity))).
