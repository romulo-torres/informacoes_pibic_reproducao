% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((dog(X) & in(X, myhouse)) => bark(X)))).
fof(p2, axiom, ! [X] : (~(ghost(X)))).
fof(p3, axiom, ! [X] : ((((bark(X) & pet(X)) & in(X, myhouse)) => ~(dead(X))))).
fof(p4, axiom, ! [X] : (((pet(X) & in(X, myhouse)) => (dead(X) <~> alive(X))))).
fof(p5, axiom, ((pet(jojo) & inmyhouse(jojo)) & ~(alive(jojo)))).
fof(extra1, axiom, (ghost(jojo))).
