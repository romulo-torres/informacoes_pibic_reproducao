% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (singer(bobbyflynn) & songwriter(bobbyflynn))).
fof(p2, axiom, ! [X] : ((competesonaustralianidol(X) => australiancitizen(X)))).
fof(p3, axiom, nationwidetourin(theomegathreeband, year2007)).
fof(p4, axiom, member(bobbyflynn, theomegathreeband)).
fof(p5, axiom, bornin(bobbyflynn, queensland)).
fof(extra1, axiom, ~(australiancitizen(bobbyflynn))).
