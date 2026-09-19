% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (playedfor(thomasbarber, astonvilla) & playedin(astonvilla, thefootballleague))).
fof(p2, axiom, (playedas(thomasbarber, halfback) & playedas(thomasbarber, insideleft))).
fof(p3, axiom, scoredthewinninggoalin(thomasbarber, facupfinal1913)).
fof(extra1, axiom, ~(? [X] : (((english(X) & professionalfootballer(X)) & scoredthewinninggoalin(X, facupfinal1913))))).
