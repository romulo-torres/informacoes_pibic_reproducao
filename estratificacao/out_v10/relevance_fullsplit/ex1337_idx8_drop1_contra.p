% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((fish(X) => ~(plant(X))))).
fof(p2, axiom, ! [X] : ((displayedin(X, collection) => (plant(X) <~> animal(X))))).
fof(p3, axiom, ! [X] : ((multicellular(X) => ~(bacteria(X))))).
fof(p4, axiom, ! [X] : (((displayedin(X, collection) & animal(X)) => multicellular(X)))).
fof(p5, axiom, displayedin(seaeel, collection)).
fof(p6, axiom, ((eel(seaeel) | animal(seaeel)) | ~(plant(seaeel)))).
fof(extra1, axiom, (bacteria(seaeel))).
