% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (debut(westworld, year2016) & tvseries(westworld))).
fof(p2, axiom, (((adapted(westworld, westworldthefilm) & produce(westworldthefilm, year1973)) & wrote(michael, westworldthefilm)) & directed(michael, westworldthefilm))).
fof(p3, axiom, (film(westworldthefilm) & about(westworldthefilm, malfunctioningrobots))).
fof(extra1, axiom, (? [X] : (((tvseries(X) & american(X)) & debut(X, year2016))))).
