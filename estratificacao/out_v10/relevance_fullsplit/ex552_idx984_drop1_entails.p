% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (capitalof(santiago, chile) & largestcityof(santiago, chile))).
fof(p2, axiom, ((daughterof(rosa, jose) & buildingcontractor(jose)) & catalan(jose))).
fof(p3, axiom, (wifeof(jose, carmen) & chilean(carmen))).
fof(p4, axiom, (parentof(jose, rosa) & parentof(carmen, rosa))).
fof(p5, axiom, ! [X] : ((catalan(X) => ~(chilean(X))))).
fof(p6, axiom, ! [X] : (? [Y] : ((buildingcontractor(X) => (constructionsite(Y) & oversee(X, Y)))))).
fof(extra1, axiom, ~(? [X] : ((bornin(rosa, X) & largestcityof(X, chile))))).
