% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((soccerplayer(X) & receive(X, twoyellowcard)) => ejectfromrestofgame(X)))).
fof(p2, axiom, (! [X] : ((soccerplayer(X) & receive(X, oneredcard))) => ejectfromrestofgame(x))).
fof(p3, axiom, soccerplayer(henry)).
fof(p4, axiom, (receive(henry, oneyellowcard) & receive(x, oneredcard))).
fof(extra1, axiom, (ejectfromrestofgame(henry))).
