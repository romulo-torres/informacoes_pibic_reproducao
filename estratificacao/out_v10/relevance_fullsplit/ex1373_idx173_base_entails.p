% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((human(X) => capableof(X, abstractthought)))).
fof(p2, axiom, ! [X] : ((plant(X) => ~(capableof(X, abstractthought))))).
fof(p3, axiom, ! [X] : (((multicellularcreature(X) & (autotrophic(X) | digestfoodinternally(X))) => (plant(X) <~> animal(X))))).
fof(p4, axiom, ! [X] : ((goat(X) => animal(X)))).
fof(p5, axiom, ! [X] : ((dirt(X) => ~(animal(X))))).
fof(p6, axiom, (goat(hulu) | humanbeing(hulu))).
fof(p7, axiom, (multicellularcreature(hulu) & (autotrophic(hulu) | digestfoodinternally(hulu)))).
fof(extra1, axiom, ~(~(capableof(hulu, abstractthought)))).
