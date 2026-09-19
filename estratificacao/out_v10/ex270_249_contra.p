% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (singer(bobbyflynn) & songwriter(bobbyflynn))).
fof(p2, axiom, (finishesin(bobbyflynn, number7) & competesonaustralianidol(bobbyflynn))).
fof(p3, axiom, ! [X] : ((competesonaustralianidol(X) => australiancitizen(X)))).
fof(p4, axiom, nationwidetourin(theomegathreeband, year2007)).
fof(p5, axiom, member(bobbyflynn, theomegathreeband)).
fof(p6, axiom, bornin(bobbyflynn, queensland)).
fof(extra1, axiom, (australiancitizen(bobbyflynn))).
