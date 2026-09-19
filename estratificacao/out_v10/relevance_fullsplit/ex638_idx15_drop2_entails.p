% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ((british(williamdickinson) & politician(williamdickinson)) & satin(williamdickinson, houseofcommons))).
fof(p2, axiom, (university(universityofedinburgh) & locatedin(universityofedinburgh, unitedkingdom))).
fof(p3, axiom, supported(williamdickinson, portlandwhigs)).
fof(p4, axiom, ! [X] : ((supported(X, portlandwhigs) => ~(satin(X, parliament))))).
fof(extra1, axiom, ~(? [X] : (((attended(williamdickinson, X) & university(X)) & locatedin(X, unitedkingdom))))).
