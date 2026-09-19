% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((workin(X, office) <~> workfrom(X, home)))).
fof(p2, axiom, ! [X] : ((workfrom(X, home) => have(X, relaxedschedule)))).
fof(p3, axiom, (commuter(george) <~> have(george, homeoffice))).
fof(p4, axiom, ((workfrom(george, home) <~> have(george, homeoffice)) => (~(workfrom(george, home)) & commuter(george)))).
fof(extra1, axiom, ((~((workfrom(george, home) & workin(george, office))) => ~((commuter(george) | have(george, relaxedschedule)))))).
