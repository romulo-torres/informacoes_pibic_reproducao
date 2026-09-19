% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((drinkregularly(X, coffee) => isdependenton(X, caffeine)))).
fof(p2, axiom, ! [X] : ((drinkregularly(X, coffee) | ~(wanttobeaddictedto(X, caffeine))))).
fof(p3, axiom, ! [X] : ((~(wanttobeaddictedto(X, caffeine)) => ~(awarethatdrug(X, caffeine))))).
fof(p4, axiom, ~((student(rina) <~> ~(awarethatdrug(rina, caffeine))))).
fof(p5, axiom, ~((isdependenton(rina, caffeine) <~> student(rina)))).
fof(extra1, axiom, ~((drinkregularly(rina, coffee) <~> isunawarethatcaffeineisadrug(rina)))).
