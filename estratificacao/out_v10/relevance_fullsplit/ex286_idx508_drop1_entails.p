% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, in(hambletondistrict, northyorkshire)).
fof(p2, axiom, in(northyorkshire, england)).
fof(p3, axiom, ! [X] : (! [Y] : (! [Z] : (((in(X, Y) & in(Y, Z)) => in(X, Z)))))).
fof(extra1, axiom, ~(~(? [X] : ((civilparish(X) & in(X, england)))))).
