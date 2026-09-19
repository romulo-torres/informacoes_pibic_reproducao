% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ((village(ainderbyquernhow) & civilparish(ainderbyquernhow)) & in(ainderbyquernhow, hambletondistrict))).
fof(p2, axiom, in(hambletondistrict, northyorkshire)).
fof(p3, axiom, in(northyorkshire, england)).
fof(p4, axiom, ! [X] : (! [Y] : (! [Z] : (((in(X, Y) & in(Y, Z)) => in(X, Z)))))).
fof(extra1, axiom, (~(? [X] : ((civilparish(X) & in(X, england)))))).
