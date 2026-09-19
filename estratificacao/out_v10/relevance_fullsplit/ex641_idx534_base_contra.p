% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ((((milanese(carrozzeriacolli) & coachbuilder(carrozzeriacolli)) & company(carrozzeriacolli)) & establishedby(carrozzeriacolli, giuseppecolli)) & establishedin(carrozzeriacolli, num1931))).
fof(p2, axiom, (company(carrozzeriacolli) & specializesin(carrozzeriacolli, usingaluminum))).
fof(p3, axiom, ! [X] : (((builtby(X, carrozzeriacolli) & firstautomobile(X)) => racingcar(X)))).
fof(p4, axiom, ? [X] : ((((builtby(X, carrozzeriacolli) & racingcar(X)) & used(X, fiat1100mechanicals)) & used(X, chassis)))).
fof(p5, axiom, ? [X] : ((airforce(X) & workedfor(carrozzeriacolli, X)))).
fof(p6, axiom, ? [X] : ((carbody(X) & made(X, carrozzeriacolli)))).
fof(extra1, axiom, (? [X] : (((airplane(X) & made(X, carrozzeriacolli)) & madeduring(X, worldwarii))))).
