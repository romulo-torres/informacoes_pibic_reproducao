% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (scottish(brianwinter) & footballreferee(brianwinter))).
fof(p2, axiom, (retired(brianwinter) & retiredin(brianwinter, yr2012))).
fof(p3, axiom, ? [X] : ((footballreferee(X) & refereeobserver(X)))).
fof(p4, axiom, ((sonof(andywinter, brianwinter) & footballplayer(andywinter)) & playsfor(andywinter, hamiltonacademical))).
fof(extra1, axiom, (~(refereeobserver(brianwinter)))).
