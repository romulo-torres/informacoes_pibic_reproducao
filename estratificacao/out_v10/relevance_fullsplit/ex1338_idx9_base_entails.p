% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((eel(X) => fish(X)))).
fof(p2, axiom, ! [X] : ((fish(X) => ~(plant(X))))).
fof(p3, axiom, ! [X] : ((displayedin(X, collection) => (plant(X) <~> animal(X))))).
fof(p4, axiom, ! [X] : ((multicellular(X) => ~(bacteria(X))))).
fof(p5, axiom, ! [X] : (((displayedin(X, collection) & animal(X)) => multicellular(X)))).
fof(p6, axiom, displayedin(seaeel, collection)).
fof(p7, axiom, ((eel(seaeel) | animal(seaeel)) | ~(plant(seaeel)))).
fof(extra1, axiom, ~((multicellular(seaeel) | bacteria(seaeel)))).
