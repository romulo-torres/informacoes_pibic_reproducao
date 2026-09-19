% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : ((professionalsoccerdefender(X) & professionalcenterback(X)))).
fof(p2, axiom, ! [X] : ((professionalsoccerdefender(X) => professionalsoccerplayer(X)))).
fof(p3, axiom, ! [X] : ((professionalsoccerplayer(X) => ~(professionalbasketballplayer(X))))).
fof(p4, axiom, ! [X] : ((nbaplayer(X) => professionalbasketballplayer(X)))).
fof(p5, axiom, nbaplayer(stephencurry)).
fof(extra1, axiom, ((~((centerback(stephencurry) & soccerdefender(stephencurry))) => ~((soccerplayer(stephencurry) | professionalbasketballplayer(stephencurry)))))).
