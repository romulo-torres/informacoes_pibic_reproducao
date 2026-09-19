% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((buisness(X) => (sanctioned(X) <~> ~(sanctioned(X)))))).
fof(p2, axiom, ! [X] : (((buisness(X) & sanctioned(X)) => limited(X)))).
fof(p3, axiom, ! [X] : (((buisness(X) & ~(sanctioned(X))) => free(X)))).
fof(p4, axiom, (buisness(crudeoildataexchange) & ~(free(crudeoildataexchange)))).
fof(extra1, axiom, ~(limited(crudeoildataexchange))).
