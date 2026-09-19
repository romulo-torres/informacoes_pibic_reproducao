% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((usedin(X, labcomputer) & unixoperatingsystem(X)) => software(X)))).
fof(p2, axiom, ! [X] : (((usedin(X, labcomputer) & macos(X)) => unixoperatingsystem(X)))).
fof(p3, axiom, ! [X] : ((usedin(X, labcomputer) => (macos(X) <~> linux(X))))).
fof(p4, axiom, ! [X] : (((usedin(X, labcomputer) & linux(X)) => convenient(X)))).
fof(p5, axiom, ! [X] : (((usedin(X, labcomputer) & software(X)) => writtenwithcode(X)))).
fof(p6, axiom, ! [X] : (((usedin(X, labcomputer) & convenient(X)) => popular(X)))).
fof(p7, axiom, ((usedin(burger, labcomputer) & writtenwithcode(burger)) & macos(burger))).
fof(p8, axiom, (usedin(pytorch, labcomputer) & ~((linux(pytorch) <~> software(pytorch))))).
fof(extra1, axiom, (~(popular(burger)))).
