% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, bornin(rosa, santiago)).
fof(p2, axiom, (capitalof(santiago, chile) & largestcityof(santiago, chile))).
fof(p3, axiom, (wifeof(jose, carmen) & chilean(carmen))).
fof(p4, axiom, (parentof(jose, rosa) & parentof(carmen, rosa))).
fof(p5, axiom, ! [X] : ((catalan(X) => ~(chilean(X))))).
fof(p6, axiom, ! [X] : (? [Y] : ((buildingcontractor(X) => (constructionsite(Y) & oversee(X, Y)))))).
fof(extra1, axiom, ((~(chilean(jose)) & ~(chilean(carmen))))).
