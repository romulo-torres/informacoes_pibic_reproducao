% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((drinkregularly(X, coffee) => isdependenton(X, caffeine)))).
fof(p2, axiom, ! [X] : ((drinkregularly(X, coffee) | ~(wanttobeaddictedto(X, caffeine))))).
fof(p3, axiom, ~((student(rina) <~> ~(awarethatdrug(rina, caffeine))))).
fof(p4, axiom, ~((isdependenton(rina, caffeine) <~> student(rina)))).
fof(extra1, axiom, ((~(wanttobeaddictedto(rina, caffeine)) | ~(awarethatdrug(rina, caffeine))))).
