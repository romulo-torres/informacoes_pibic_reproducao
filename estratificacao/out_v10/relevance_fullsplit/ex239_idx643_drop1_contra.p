% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, officein(ableton, unitedstates)).
fof(p2, axiom, ~(samecountry(germany, unitedstates))).
fof(p3, axiom, ! [X] : (! [Y] : (! [Z] : ((((officein(X, Y) & officein(X, Z)) & ~(samecountry(Y, Z))) => multinationalcompany(X)))))).
fof(p4, axiom, makesmusicsoftware(ableton)).
fof(extra1, axiom, (~(officein(ableton, germany)))).
