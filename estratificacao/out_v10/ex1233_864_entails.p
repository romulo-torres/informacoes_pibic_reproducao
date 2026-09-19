% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((yaledormitory(X) => locatedon(X, yalecampus)))).
fof(p2, axiom, ! [X] : (((yalebuildings(X) & managedby(X, yalehousing)) => yaledormitory(X)))).
fof(p3, axiom, ! [X] : (((yalebuildings(X) & operatedby(X, yalehousingstaff)) => managedby(X, yalehousing)))).
fof(p4, axiom, ! [X] : (((yalebuildings(X) & opentostudents(X)) => ~(? [Y] : ((before(Y, yr1701) & established(X, Y))))))).
fof(p5, axiom, ! [X] : (((yalebuildings(X) & locatedon(X, yalecampus)) => opentostudents(X)))).
fof(p6, axiom, (yalebuildings(harkness) & (operatedby(x, harkness) <~> locatedon(harkness, yalecampus)))).
fof(extra1, axiom, ~(? [Y] : ((before(Y, year1701) & established(x, Y))))).
