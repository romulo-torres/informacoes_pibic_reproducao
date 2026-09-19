% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((workin(X, office) => commuter(X)))).
fof(p2, axiom, ! [X] : ((workin(X, office) <~> workfrom(X, home)))).
fof(p3, axiom, ! [X] : ((workfrom(X, home) => have(X, relaxedschedule)))).
fof(p4, axiom, (commuter(george) <~> have(george, homeoffice))).
fof(p5, axiom, ((workfrom(george, home) <~> have(george, homeoffice)) => (~(workfrom(george, home)) & commuter(george)))).
fof(extra1, axiom, ~(workfrom(george, home))).
