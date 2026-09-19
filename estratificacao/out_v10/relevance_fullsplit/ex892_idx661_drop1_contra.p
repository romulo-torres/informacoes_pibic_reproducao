% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((worldtourplayer(X) => professionaltennisplayer(X)))).
fof(p2, axiom, ! [X] : ((grandslamchampion(X) => worldtourplayer(X)))).
fof(p3, axiom, ! [X] : ((grandslamumpire(X) => professionaltennisumpire(X)))).
fof(p4, axiom, (worldtourplayer(nadal) | grandslamchampion(nadal))).
fof(extra1, axiom, (((grandslamumpire(nadal) | professionaltennisplayer(nadal)) => grandslamumpire(nadal)))).
