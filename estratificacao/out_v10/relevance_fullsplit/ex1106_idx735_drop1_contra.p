% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((at(X, boardgamenight) & badat(X, chess)) => ~(playsoften(X, chess))))).
fof(p2, axiom, ? [X] : ((at(X, boardgamenight) & (planner(X) | creative(X))))).
fof(p3, axiom, (at(erica, boardgamenight) & playsoften(erica, chess))).
fof(p4, axiom, ((at(erica, boardgamenight) & ~((badat(erica, chess) | creative(erica)))) => ~((planner(erica) <~> creative(erica))))).
fof(extra1, axiom, (((playsoften(erica, chess) <~> interestedin(erica, puzzle)) => ~((interestedin(erica, puzzle) | playsoften(erica, chess)))))).
