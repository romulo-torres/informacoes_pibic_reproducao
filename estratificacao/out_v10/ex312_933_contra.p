% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ((from(edwinsmith, newzealand) & rower(edwinsmith)) & from(edwinsmith, auckland))).
fof(p2, axiom, (edwinsmith = tedsmith)).
fof(p3, axiom, (goto(edwinsmith, roseroadprimaryschool) & locatedin(roseroadprimaryschool, greylynn))).
fof(p4, axiom, (((sergeant(edwinsmith) & servewith(edwinsmith, newzealand24thbattalion)) & servein(edwinsmith, italy)) & servein(edwinsmith, egypt))).
fof(p5, axiom, (((buisness(broadwaysheetmetals) & run(edwinsmith, broadwaysheetmetals)) & own(edwinsmith, broadwaysheetmetals)) & sheetmetalworker(edwinsmith))).
fof(extra1, axiom, (! [X] : (! [Y] : (((buisness(X) & own(Y, X)) => ~(servein(Y, egypt))))))).
