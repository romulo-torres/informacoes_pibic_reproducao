% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, useassurname(albaroversi, roversi)).
fof(p2, axiom, useassurname(paoloroversi, roversi)).
fof(p3, axiom, useassurname(robertoroversi, roversi)).
fof(p4, axiom, photographer(paoloroversi)).
fof(p5, axiom, ! [X] : ((photographer(X) => (professional(X) <~> amateur(X))))).
fof(extra1, axiom, (? [X] : (((italianname(X) & surname(X)) & useassurname(albaroversi, X))))).
