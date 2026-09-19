% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((choosewhattodowith(X, time) => flexibleschedule(X)))).
fof(p2, axiom, ! [X] : ((have(X, lotsoffreetime) => choosewhattodowith(X, time)))).
fof(p3, axiom, ! [X] : ((have(X, lotsoffreetime) <~> ? [Y] : (((investin(X, Y) & career(Y)) & willingtospendin(restoflife, Y)))))).
fof(p4, axiom, ! [X] : ((? [Y] : (((investin(X, Y) & career(Y)) & willingtospendin(restoflife, Y))) => hardworking(X)))).
fof(p5, axiom, ! [X] : ((((hardworking(X) & havefor(X, highambition, future)) & havefor(X, goal, future)) => ~(shortsighted(X))))).
fof(p6, axiom, ~((((hardworking(john) & havefor(john, highambition, future)) & havefor(john, goal, future)) <~> flexibleschedule(john)))).
fof(extra1, axiom, ~(organized(john))).
