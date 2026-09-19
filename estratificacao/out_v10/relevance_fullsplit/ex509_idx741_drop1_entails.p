% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, opentovisitor(nationallobsterhatchery)).
fof(p2, axiom, ! [X] : ((hatchery(X) => (forconservation(X) <~> forprofit(X))))).
fof(p3, axiom, ? [X] : (((hatchery(X) & forconservation(X)) & releaseanimaltowild(X)))).
fof(p4, axiom, ~(forprofit(nationallobsterhatchery))).
fof(extra1, axiom, ~(forconservation(nationallobsterhatchery))).
