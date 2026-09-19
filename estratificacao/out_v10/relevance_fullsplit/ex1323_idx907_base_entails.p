% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((shoe(X) => ~(food(X))))).
fof(p2, axiom, ! [X] : ((slipper(X) => shoe(X)))).
fof(p3, axiom, ! [X] : ((donatedto(X, homelesscharity) => (food(X) <~> clothes(X))))).
fof(p4, axiom, ! [X] : ((wearable(X) => ~(edible(X))))).
fof(p5, axiom, ! [X] : ((clothes(X) => wearable(X)))).
fof(p6, axiom, donatedto(watch, homelesscharify)).
fof(p7, axiom, (~((edible(watch) & clothes(watch))) => ~((edible(watch) <~> clothes(watch))))).
fof(extra1, axiom, ~((~(edible(watch)) & ~(slipper(watch))))).
