% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((big(X) & in(X, sizetown)) => heavy(X)))).
fof(p2, axiom, ! [X] : (((small(X) & in(X, sizetown)) => light(X)))).
fof(p3, axiom, ! [X] : (((heavy(X) & in(X, sizetown)) => still(X)))).
fof(p4, axiom, ! [X] : (((light(X) & in(X, sizetown)) => unstable(X)))).
fof(p5, axiom, ! [X] : (((unstable(X) & in(X, sizetown)) => changing(X)))).
fof(p6, axiom, ! [X] : (((unstable(X) & in(X, sizetown)) => unpredictable(X)))).
fof(p7, axiom, (in(bird, sizetown) & ~((heavy(bird) & still(bird))))).
fof(extra1, axiom, ~((unpredictable(bird) <~> changing(bird)))).
