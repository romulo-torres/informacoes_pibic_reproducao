% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ((british(williamdickinson) & politician(williamdickinson)) & satin(williamdickinson, houseofcommons))).
fof(p2, axiom, ((attended(williamdickinson, westminsterschool) & highschool(westminsterschool)) & attended(williamdickinson, universityofedinburgh))).
fof(p3, axiom, (university(universityofedinburgh) & locatedin(universityofedinburgh, unitedkingdom))).
fof(p4, axiom, supported(williamdickinson, portlandwhigs)).
fof(p5, axiom, ! [X] : ((supported(X, portlandwhigs) => ~(satin(X, parliament))))).
fof(extra1, axiom, (satin(williamdickinson, houseofcommons))).
