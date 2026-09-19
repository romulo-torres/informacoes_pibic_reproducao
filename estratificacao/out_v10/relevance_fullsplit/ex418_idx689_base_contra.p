% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (memberof(annjland, philadelphiacitycouncil) & memberof(annjland, democraticparty))).
fof(p2, axiom, rununopposedfor(ann, philadelphiacitycouncil, year1980)).
fof(p3, axiom, ! [X] : (! [Y] : ((rununopposedfor(X, philadelphiacitycouncil, Y) => electedto(X, philadelphiacitycouncil, Y))))).
fof(p4, axiom, politicalchallenger(michaelnutter)).
fof(p5, axiom, (defeat(annjland, michaelnutter) & runfor(annjland, philadelphiacitycouncil, year1987))).
fof(extra1, axiom, (? [X] : ((memberof(X, democraticparty) & electedto(X, philadelphiacouncil, year1980))))).
