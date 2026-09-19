% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (! [Y] : (((summerolympicsin(X, Y) & in(X, unitedstates)) => summerolympicsin(X, unitedstates))))).
fof(p2, axiom, ! [X] : (! [Y] : (((in(X, Y) & in(Y, unitedstates)) => in(X, unitedstates))))).
fof(p3, axiom, ! [X] : (! [Y] : (! [Z] : ((((in(X, Z) & state(Z)) & summerolympicsin(X, Y)) => summerolympicsin(Z, Y)))))).
fof(p4, axiom, summerolympicsin(losangeles, yr2028)).
fof(p5, axiom, in(losangeles, california)).
fof(p6, axiom, in(atlanta, unitedstates)).
fof(p7, axiom, in(california, unitedstates)).
fof(p8, axiom, in(atlanta, georgia)).
fof(p9, axiom, ((~(insummerolympicsin(boxing, yr2028)) & ~(insummerolympicsin(modern_pentathlon, yr2028))) & ~(insummerolympicsin(weightlifting, yr2028)))).
fof(p10, axiom, summerolympicsin(atlanta, yr1996)).
fof(extra1, axiom, ~(~(summerolympicsin(georgia, yr1996)))).
