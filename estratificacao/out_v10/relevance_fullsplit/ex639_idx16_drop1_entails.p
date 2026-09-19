% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ((attended(williamdickinson, westminsterschool) & highschool(westminsterschool)) & attended(williamdickinson, universityofedinburgh))).
fof(p2, axiom, (university(universityofedinburgh) & locatedin(universityofedinburgh, unitedkingdom))).
fof(p3, axiom, supported(williamdickinson, portlandwhigs)).
fof(p4, axiom, ! [X] : ((supported(X, portlandwhigs) => ~(satin(X, parliament))))).
fof(extra1, axiom, ~(satin(williamdickinson, houseofcommons))).
