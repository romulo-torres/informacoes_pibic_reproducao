% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((person(X) & can(X, distinguishthetasteofdifferentcondiments)) => can(X, usedifferentcondimentstocook)))).
fof(p2, axiom, ! [X] : (((person(X) & has(X, talentofcooking)) => can(X, distinguishthetasteofdifferentcondiments)))).
fof(p3, axiom, ! [X] : (! [Y] : (((((canmake(X, Y) & meal(Y)) & delicious(Y)) & person(X)) => has(X, talentofcooking))))).
fof(p4, axiom, ! [X] : (! [Y] : (((meal(Y) & popularat(Y, party)) => delicious(Y))))).
fof(p5, axiom, ? [X] : ((((person(john) & makemeal(john, X)) & meal(X)) & popularat(X, party)))).
fof(extra1, axiom, (~(can(john, usedifferentcondimentstocook)))).
