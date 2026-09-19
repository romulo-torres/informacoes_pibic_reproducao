% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (company(carrozzeriacolli) & specializesin(carrozzeriacolli, usingaluminum))).
fof(p2, axiom, ! [X] : (((builtby(X, carrozzeriacolli) & firstautomobile(X)) => racingcar(X)))).
fof(p3, axiom, ? [X] : ((((builtby(X, carrozzeriacolli) & racingcar(X)) & used(X, fiat1100mechanicals)) & used(X, chassis)))).
fof(p4, axiom, ? [X] : ((airforce(X) & workedfor(carrozzeriacolli, X)))).
fof(p5, axiom, ? [X] : ((carbody(X) & made(X, carrozzeriacolli)))).
fof(extra1, axiom, ~(? [X] : (? [Y] : ((((company(X) & establishedby(X, giuseppecolli)) & carbody(Y)) & made(Y, X)))))).
