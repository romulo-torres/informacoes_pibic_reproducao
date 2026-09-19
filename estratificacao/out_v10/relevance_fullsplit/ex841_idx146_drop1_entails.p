% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((nbaplayer(X) => professionalbasketballplayer(X)))).
fof(p2, axiom, ! [X] : ((professionalsoccerdefender(X) => professionalsoccerplayer(X)))).
fof(p3, axiom, ! [X] : ((professionalcenterback(X) => professionalsoccerdefender(X)))).
fof(p4, axiom, ((nbaplayer(stephencurry) <~> professionalsoccerplayer(stephencurry)) => professionalbasketballplayer(stephencurry))).
fof(extra1, axiom, ~(professionalcenterback(stephencurry))).
