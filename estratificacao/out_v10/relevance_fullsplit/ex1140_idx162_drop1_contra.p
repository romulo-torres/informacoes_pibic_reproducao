% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((in(X, yalesvarsityteam) => (struggleat(X, halfcourtshot) | goodat(X, threes))))).
fof(p2, axiom, ! [X] : (((in(X, yalesvarsityteam) & goodat(X, threes)) => goodat(X, twos)))).
fof(p3, axiom, ! [X] : (((in(X, yalesvarsityteam) & goodat(X, twos)) => badat(X, midrangeshot)))).
fof(p4, axiom, (in(jack, yalesvarsityteam) & (trickshotartist(jack) <~> goodat(jack, threes)))).
fof(extra1, axiom, (((badat(jack, midrangeshot) & goodat(jack, twos)) => (~(goodat(jack, twos)) & goodat(jack, threes))))).
