% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (american(westworld) & sciencefictionthriller(westworld))).
fof(p2, axiom, (debut(westworld, year2016) & tvseries(westworld))).
fof(p3, axiom, (film(westworldthefilm) & about(westworldthefilm, malfunctioningrobots))).
fof(extra1, axiom, ~(? [X] : (((film(X) & directed(michael, X)) & about(X, malfunctioningrobots))))).
