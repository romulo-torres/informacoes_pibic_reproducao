% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((professionalsoccerplayer(X) => ~(professionalbasketballplayer(X))))).
fof(p2, axiom, ! [X] : ((nbaplayer(X) => professionalbasketballplayer(X)))).
fof(p3, axiom, ! [X] : ((professionalsoccerdefender(X) => professionalsoccerplayer(X)))).
fof(p4, axiom, ! [X] : ((professionalcenterback(X) => professionalsoccerdefender(X)))).
fof(p5, axiom, ((nbaplayer(stephencurry) <~> professionalsoccerplayer(stephencurry)) => professionalbasketballplayer(stephencurry))).
fof(extra1, axiom, (professionalcenterback(stephencurry))).
