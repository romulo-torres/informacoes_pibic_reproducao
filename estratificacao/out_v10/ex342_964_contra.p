% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (italianname(roversi) & surname(roversi))).
fof(p2, axiom, useassurname(albaroversi, roversi)).
fof(p3, axiom, useassurname(paoloroversi, roversi)).
fof(p4, axiom, useassurname(robertoroversi, roversi)).
fof(p5, axiom, photographer(paoloroversi)).
fof(p6, axiom, ! [X] : ((photographer(X) => (professional(X) <~> amateur(X))))).
fof(extra1, axiom, (~(? [X] : (? [Y] : ((((photographer(X) & italianname(Y)) & surname(Y)) & useassurname(X, Y))))))).
