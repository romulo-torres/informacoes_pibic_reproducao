% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, doesolympicsport(carlosreyes)).
fof(p2, axiom, goestoolympicgames(carlosreyes)).
fof(p3, axiom, welterweight(carlosreyes)).
fof(p4, axiom, ! [X] : ((welterweight(X) => ~(heavyweight(X))))).
fof(extra1, axiom, ~(heavyweight(carlosreyes))).
