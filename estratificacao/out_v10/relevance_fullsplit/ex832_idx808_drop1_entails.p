% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((professional(X) & soccerplayer(X)) => ~((professional(X) & basketballplayer(X)))))).
fof(p2, axiom, ! [X] : (((professional(X) & centerback(X)) => (professional(X) & defender(X))))).
fof(p3, axiom, ! [X] : ((nbaplayer(X) => (professional(X) & basketballplayer(X))))).
fof(p4, axiom, nbaplayer(stephencurry)).
fof(extra1, axiom, ~((professional(stephencurry) & centerback(stephencurry)))).
