% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((doesolympicsport(X) & goestoolympicgames(X)) => olympian(X)))).
fof(p2, axiom, doesolympicsport(carlosreyes)).
fof(p3, axiom, goestoolympicgames(carlosreyes)).
fof(p4, axiom, welterweight(carlosreyes)).
fof(p5, axiom, ! [X] : ((welterweight(X) => ~(heavyweight(X))))).
fof(extra1, axiom, (wonolympicmedal(carlosreyes))).
