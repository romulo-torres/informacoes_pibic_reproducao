% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((customer(X) => (choose(X, primevideoplan) | choose(X, hbomaxplan))))).
fof(p2, axiom, ! [X] : (((customer(X) & choose(X, hbomaxplan)) => rewardwith(X, giftcard)))).
fof(p3, axiom, ! [X] : ((customer(X) => ? [Y] : ((plan(Y) & choose(X, Y)))))).
fof(p4, axiom, ! [X] : (((customer(X) & rewardwith(X, giftcard)) => ~(olderthan(X, num80))))).
fof(p5, axiom, ! [X] : ((customer(X) => (? [Y] : ((greaterthan(Y, num80) & age(james, Y))) <~> ? [Y] : ((between(Y, num60, num80) & age(james, Y))))))).
fof(p6, axiom, (customer(james) & ~(? [Y] : ((between(Y, num60, num80) & age(james, Y)))))).
fof(extra1, axiom, ~(((choose(james, plana) | choose(james, noplan)) => (rewardwith(james, giftcard) <~> choose(james, planb))))).
