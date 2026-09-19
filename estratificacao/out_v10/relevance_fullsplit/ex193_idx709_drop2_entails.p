% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (! [Y] : (((coach(X, Y) & footballclub(Y)) => footballcoach(X))))).
fof(p2, axiom, footballclub(minnesotavikings)).
fof(p3, axiom, coach(dennisgreen, minnesotavikings)).
fof(p4, axiom, receivetd(criscarter, num13)).
fof(p5, axiom, innfl(minnesotavikings, yr1997)).
fof(p6, axiom, playpositionfor(johnrandle, defensivetackle, minnesotavikings, yr1997)).
fof(extra1, axiom, ~(~(playinnfl(johnrandle)))).
