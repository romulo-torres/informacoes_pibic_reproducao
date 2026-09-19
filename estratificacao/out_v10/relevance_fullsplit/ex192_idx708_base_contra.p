% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (! [Y] : (((coach(X, Y) & footballclub(Y)) => footballcoach(X))))).
fof(p2, axiom, ! [W] : (! [X] : (! [Y] : (! [Z] : (((playpositionfor(X, W, Y, Z) & innfl(Y, Z)) => playinnfl(X))))))).
fof(p3, axiom, footballclub(minnesotavikings)).
fof(p4, axiom, coach(dennisgreen, minnesotavikings)).
fof(p5, axiom, receivetd(criscarter, num13)).
fof(p6, axiom, innfl(minnesotavikings, yr1997)).
fof(p7, axiom, playpositionfor(johnrandle, defensivetackle, minnesotavikings, yr1997)).
fof(extra1, axiom, (footballcoach(dennisgreen))).
