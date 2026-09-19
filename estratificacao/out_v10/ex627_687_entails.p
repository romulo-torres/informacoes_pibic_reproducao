% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (polish(ernestpohl) & footballplayer(ernestpohl))).
fof(p2, axiom, ? [X] : (((footballplayer(X) & in(X, polishfirstdivision)) & scoredover(X, c_180goals)))).
fof(p3, axiom, (in(ernestpohl, polishfirstdivision) & scoredover(ernestpohl, c_180goals))).
fof(p4, axiom, ? [X] : (? [Y] : (((((gornikzabrzes(X) & stadium(X)) & namedafter(X, Y)) & soccerplayer(Y)) & from(Y, rudaslaska))))).
fof(p5, axiom, from(ernestpohl, rudaslaska)).
fof(extra1, axiom, ~(! [X] : (((gornikzabrzes(X) & stadium(X)) => namedafter(X, ernestpohl))))).
