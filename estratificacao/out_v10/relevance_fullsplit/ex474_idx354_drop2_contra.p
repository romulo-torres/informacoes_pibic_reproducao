% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ((europeancountry(belgium) & europeancountry(france)) & europeancountry(germany))).
fof(p2, axiom, (touristattraction(eiffeltower) & locatedin(eiffeltower, paris))).
fof(p3, axiom, ? [X] : ((livein(X, belgium) => speak(X, french)))).
fof(p4, axiom, ? [X] : ((goto(john, europe) => (see(john, X) & touristattraction(X))))).
fof(p5, axiom, speak(john, french)).
fof(extra1, axiom, (? [X] : ((capitalof(X, france) & locatedin(eiffeltower, X))))).
