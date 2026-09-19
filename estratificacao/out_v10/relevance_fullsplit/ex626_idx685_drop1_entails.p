% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ? [X] : (((footballplayer(X) & in(X, polishfirstdivision)) & scoredover(X, c_180goals)))).
fof(p2, axiom, (in(ernestpohl, polishfirstdivision) & scoredover(ernestpohl, c_180goals))).
fof(p3, axiom, ? [X] : (? [Y] : (((((gornikzabrzes(X) & stadium(X)) & namedafter(X, Y)) & soccerplayer(Y)) & from(Y, rudaslaska))))).
fof(p4, axiom, from(ernestpohl, rudaslaska)).
fof(extra1, axiom, ~(~(scoredover(ernestpohl, c_180goals)))).
