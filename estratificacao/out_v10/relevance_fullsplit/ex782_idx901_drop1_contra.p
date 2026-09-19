% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((human(X) => animal(X)))).
fof(p2, axiom, ! [X] : ((pupil(X) => human(X)))).
fof(p3, axiom, ! [X] : ((flower(X) => plant(X)))).
fof(p4, axiom, ~((human(bailey) <~> flower(bailey)))).
fof(extra1, axiom, (pupil(bailey))).
