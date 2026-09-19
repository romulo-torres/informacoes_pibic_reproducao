% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((doesolympicsport(X) & goestoolympicgames(X)) => olympian(X)))).
fof(p2, axiom, goestoolympicgames(carlosreyes)).
fof(p3, axiom, welterweight(carlosreyes)).
fof(p4, axiom, ! [X] : ((welterweight(X) => ~(heavyweight(X))))).
fof(extra1, axiom, (heavyweight(carlosreyes))).
