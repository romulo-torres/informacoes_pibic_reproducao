% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, heldin(c_2008summerolympics, beijingchina)).
fof(p2, axiom, (secondsummerolympicsgames(c_2008summerolympics) & beheldin(c_2008summerolympics, communiststate))).
fof(p3, axiom, won(china, themostgoldmedals)).
fof(p4, axiom, (placedsecondingoldmedalsin(unitedstates, c_2008summerolympics) & won(unitedstates, highestnumberofmedals))).
fof(p5, axiom, placedthirdingoldmedalsin(russia, c_2008summerolympics)).
fof(p6, axiom, ! [X] : (! [Y] : (((placed(X, thirdingoldmedals) & won(Y, mostgoldmedals)) => fewergoldmedalsthan(X, Y))))).
fof(extra1, axiom, ~(~(fewergoldmedalsthan(russia, china)))).
