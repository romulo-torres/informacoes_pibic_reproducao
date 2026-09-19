% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, rununopposedfor(ann, philadelphiacitycouncil, year1980)).
fof(p2, axiom, ! [X] : (! [Y] : ((rununopposedfor(X, philadelphiacitycouncil, Y) => electedto(X, philadelphiacitycouncil, Y))))).
fof(p3, axiom, politicalchallenger(michaelnutter)).
fof(p4, axiom, (defeat(annjland, michaelnutter) & runfor(annjland, philadelphiacitycouncil, year1987))).
fof(extra1, axiom, ~(electedto(ann, philadelphiacitycouncil, year1980))).
