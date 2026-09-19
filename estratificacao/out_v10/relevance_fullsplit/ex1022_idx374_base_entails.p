% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((inthismidwesttown(X) & have(X, horseranch)) => regularlyridehorseforpleasure(X)))).
fof(p2, axiom, ! [X] : (((inthismidwesttown(X) & have(X, disposableincome)) => have(X, horserank)))).
fof(p3, axiom, ! [X] : (((inthismidwesttown(X) & competein(X, horsedressageshow)) => have(X, disposableincome)))).
fof(p4, axiom, ! [X] : (((inthismidwesttown(X) & competein(X, horsedressageshow)) => investedin(X, equestriangearandequipment)))).
fof(p5, axiom, ! [X] : (((inthismidwesttown(X) & regularlyridehorseforpleasure(X)) => ~(livein(X, crampedbuilding))))).
fof(p6, axiom, (inthismidwesttown(manny) & ~((have(manny, horseranch) <~> livein(manny, crampedbuilding))))).
fof(extra1, axiom, ~((~((haveahorseranch(manny) <~> competein(manny, horsedressageshow))) => ~(investedin(manny, equestriangearandequipment))))).
