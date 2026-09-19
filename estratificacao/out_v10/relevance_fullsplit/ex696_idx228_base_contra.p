% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((country(X) & possibleeffectivemonetarypolicy(X)) => (successfulinflationcontrol(X) & stongnationalcurrency(X))))).
fof(p2, axiom, ~(? [X] : (((country(X) & successfulinflationcontrol(X)) & regulateexchangerate(X))))).
fof(p3, axiom, ! [X] : ((introductionofon(X, embargo, foreighttradegoods) => sharpdecreasesinexport(X)))).
fof(p4, axiom, ! [X] : ((sharpdecreasesinexport(X) => ~(stongnationalcurrency(X))))).
fof(p5, axiom, ! [X] : ((inflationcontrol(X) => stongnationalcurrency(X)))).
fof(p6, axiom, introductionofon(russia, embargo, foreighttradegoods)).
fof(extra1, axiom, (possibleeffectivemonetarypolicy(russia))).
