% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((human(X) & canturninto(X, wolf)) => werewolf(X)))).
fof(p2, axiom, ! [X] : (? [Y] : ((werewolf(X) => ((bittenby(X, Y) | scratchedby(X, Y)) & werewolf(Y)))))).
fof(p3, axiom, (! [X] : (? [Y] : ((bittenby(X, Y) | scratchedby(X, Y)))) => attackedby(x, y))).
fof(extra1, axiom, ~(! [X] : (? [Y] : ((werewolf(X) => scratchedby(Y, X)))))).
