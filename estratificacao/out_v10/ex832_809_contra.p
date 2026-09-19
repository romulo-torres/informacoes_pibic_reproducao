% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((professional(X) & defender(X)) => (professional(X) & soccerplayer(X))))).
fof(p2, axiom, ! [X] : (((professional(X) & soccerplayer(X)) => ~((professional(X) & basketballplayer(X)))))).
fof(p3, axiom, ! [X] : (((professional(X) & centerback(X)) => (professional(X) & defender(X))))).
fof(p4, axiom, ! [X] : ((nbaplayer(X) => (professional(X) & basketballplayer(X))))).
fof(p5, axiom, nbaplayer(stephencurry)).
fof(extra1, axiom, ((professional(stephencurry) & centerback(stephencurry)))).
