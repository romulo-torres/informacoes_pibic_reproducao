% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, officein(ableton, germany)).
fof(p2, axiom, officein(ableton, unitedstates)).
fof(p3, axiom, ~(samecountry(germany, unitedstates))).
fof(p4, axiom, ! [X] : (! [Y] : (! [Z] : ((((officein(X, Y) & officein(X, Z)) & ~(samecountry(Y, Z))) => multinationalcompany(X)))))).
fof(p5, axiom, makesmusicsoftware(ableton)).
fof(extra1, axiom, ~(~(officein(ableton, germany)))).
