% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (scottish(brianwinter) & footballreferee(brianwinter))).
fof(p2, axiom, (retired(brianwinter) & retiredin(brianwinter, yr2012))).
fof(p3, axiom, refereeobserver(brianwinter)).
fof(p4, axiom, ? [X] : ((footballreferee(X) & refereeobserver(X)))).
fof(p5, axiom, ((sonof(andywinter, brianwinter) & footballplayer(andywinter)) & playsfor(andywinter, hamiltonacademical))).
fof(extra1, axiom, ~(retired(brianwinter))).
