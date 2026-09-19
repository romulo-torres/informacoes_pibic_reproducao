% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((buisness(X) => (sanctioned(X) <~> ~(sanctioned(X)))))).
fof(p2, axiom, ! [X] : (((buisness(X) & ~(sanctioned(X))) => free(X)))).
fof(p3, axiom, (buisness(crudeoildataexchange) & ~(free(crudeoildataexchange)))).
fof(extra1, axiom, ~(limited(crudeoildataexchange))).
