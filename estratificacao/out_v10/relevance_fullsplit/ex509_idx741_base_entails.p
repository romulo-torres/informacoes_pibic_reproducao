% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (hatchery(nationallobsterhatchery) & locatedin(nationallobsterhatchery, padstowengland))).
fof(p2, axiom, opentovisitor(nationallobsterhatchery)).
fof(p3, axiom, ! [X] : ((hatchery(X) => (forconservation(X) <~> forprofit(X))))).
fof(p4, axiom, ? [X] : (((hatchery(X) & forconservation(X)) & releaseanimaltowild(X)))).
fof(p5, axiom, ~(forprofit(nationallobsterhatchery))).
fof(extra1, axiom, ~(forconservation(nationallobsterhatchery))).
