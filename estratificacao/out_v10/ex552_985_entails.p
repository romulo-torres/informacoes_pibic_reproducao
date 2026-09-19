% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, bornin(rosa, santiago)).
fof(p2, axiom, (capitalof(santiago, chile) & largestcityof(santiago, chile))).
fof(p3, axiom, ((daughterof(rosa, jose) & buildingcontractor(jose)) & catalan(jose))).
fof(p4, axiom, (wifeof(jose, carmen) & chilean(carmen))).
fof(p5, axiom, (parentof(jose, rosa) & parentof(carmen, rosa))).
fof(p6, axiom, ! [X] : ((catalan(X) => ~(chilean(X))))).
fof(p7, axiom, ! [X] : (? [Y] : ((buildingcontractor(X) => (constructionsite(Y) & oversee(X, Y)))))).
fof(extra1, axiom, ~(? [X] : ((bornin(rosa, X) & largestcityof(X, chile))))).
