% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((in(X, potterville) & yell(X)) => ~(cool(X))))).
fof(p2, axiom, ! [X] : (((in(X, potterville) & angry(X)) => yell(X)))).
fof(p3, axiom, ! [X] : (((in(X, potterville) & fly(X)) => cool(X)))).
fof(p4, axiom, ! [X] : (((in(X, potterville) & know(X, magic)) => fly(X)))).
fof(p5, axiom, ! [X] : (((in(X, potterville) & wizard(X)) => know(X, magic)))).
fof(p6, axiom, (in(harry, potterville) & (yell(harry) <~> fly(harry)))).
fof(p7, axiom, (wizard(potter) & fly(potter))).
fof(extra1, axiom, (cool(harry))).
