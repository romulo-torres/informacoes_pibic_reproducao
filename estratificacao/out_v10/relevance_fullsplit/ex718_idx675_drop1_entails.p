% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((footballplayer(X) & european(X)) => ? [Y] : ((call(american, Y, soccer) & play(X, Y)))))).
fof(extra1, axiom, ~(? [Y] : ((call(american, Y, soccer) & play(adambuska, Y))))).
