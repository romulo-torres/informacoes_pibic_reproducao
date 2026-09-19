% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((like(X, financialrisk) => (investinregularly(X, publicstockmarket) | enjoyregularly(X, gambling))))).
fof(p2, axiom, ! [X] : ((investinregularly(X, publicstockmarket) => (readtokeepupdatedon(X, thewallstreetjournal, financialmetric) | ? [Y] : (((~((Y = thewallstreetjournal)) & newspaper(Y)) & readtokeepupdatedon(X, Y, financialmetric))))))).
fof(p3, axiom, ! [X] : ((enjoyregularly(X, gambling) => (spendat(X, alotofmoney, casino) | ? [Y] : (((~((Y = casino)) & bettinggame(Y)) & spendat(X, alotofmoney, Y))))))).
fof(p4, axiom, ! [X] : (((spendat(X, alotofmoney, casino) | ? [Y] : (((~((Y = casino)) & bettinggame(Y)) & spendat(X, alotofmoney, Y)))) => enjoyvisiting(X, thelasvegasstrip)))).
fof(p5, axiom, ! [X] : ((spendat(X, alotofmoney, casino) | (? [Y] : (((~((Y = casino)) & bettinggame(Y)) & spendat(X, alotofmoney, Y))) => atriskof(X, gamblingaddiction))))).
fof(p6, axiom, investinregularly(matt, publicstockmarket)).
fof(p7, axiom, like(matt, financialrisk)).
fof(extra1, axiom, (newspapers(matt))).
