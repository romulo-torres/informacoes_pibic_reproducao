% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (nationalpark(phuocbinh) & locatedin(phuocbinh, vietnam))).
fof(p2, axiom, ? [X] : (((nationalpark(X) & locatedin(X, vietnam)) & unescoworldheritagesite(X)))).
fof(p3, axiom, ! [X] : (((nationalpark(X) & locatedin(X, vietnam)) => (mangedby(X, ministryofagriculture) <~> managedby(X, peoplescommittee))))).
fof(p4, axiom, ~(mangedby(phuocbinh, ministryofagriculture))).
fof(extra1, axiom, (? [X] : ((naturereserve(X) & locatedin(X, vietnam))))).
