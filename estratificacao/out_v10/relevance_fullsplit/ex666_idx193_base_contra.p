% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (american(westworld) & sciencefictionthriller(westworld))).
fof(p2, axiom, (debut(westworld, year2016) & tvseries(westworld))).
fof(p3, axiom, (((adapted(westworld, westworldthefilm) & produce(westworldthefilm, year1973)) & wrote(michael, westworldthefilm)) & directed(michael, westworldthefilm))).
fof(p4, axiom, (film(westworldthefilm) & about(westworldthefilm, malfunctioningrobots))).
fof(extra1, axiom, (? [X] : (((film(X) & directed(michael, X)) & about(X, malfunctioningrobots))))).
