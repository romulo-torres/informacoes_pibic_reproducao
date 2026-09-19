% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((mammal(X) & layegg(X)) => (platypus(X) <~> echidna(X))))).
fof(p2, axiom, ! [X] : ((platypuses(X) => ~(hyrax(X))))).
fof(p3, axiom, ! [X] : ((echidnas(X) => ~(hyrax(X))))).
fof(p4, axiom, ! [X] : ((mammal(X) => ~(invertebrate(X))))).
fof(p5, axiom, ! [X] : ((animal(X) => (vertebrate(X) | invertebrate(X))))).
fof(p6, axiom, ! [X] : ((mammal(X) => animal(X)))).
fof(p7, axiom, ! [X] : ((hyrax(X) => mammal(X)))).
fof(p8, axiom, ! [X] : ((grebes(X) => layegg(X)))).
fof(p9, axiom, ! [X] : ((grebes(X) => (~(platypuses(X)) & ~(echidnas(X)))))).
fof(extra1, axiom, ~(? [X] : ((hyrax(X) & layegg(X))))).
