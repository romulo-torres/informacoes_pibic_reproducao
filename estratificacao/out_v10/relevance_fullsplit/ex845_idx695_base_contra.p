% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((youngworkingprofessional(X) & have(X, regular9to5job)) => have(X, stablejob)))).
fof(p2, axiom, ? [X] : (((livein(X, manhattan) & youngworkingprofessional(X)) & have(X, regular9to5job)))).
fof(p3, axiom, ! [X] : ((have(X, stablejob) => workregularly(X)))).
fof(p4, axiom, ! [X] : ((workregularly(X) => ~(disobeyfrequently(X, boss))))).
fof(p5, axiom, ~((disobeyfrequently(mary, boss) <~> workregularly(mary)))).
fof(extra1, axiom, (((youngworkingprofessional(mary) & have(mary, regular9_5job)) => ~(livein(mary, manhattan))))).
