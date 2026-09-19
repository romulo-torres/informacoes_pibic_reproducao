% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((neuroimagingtechnique(X) => (invasive(X) <~> noninvasive(X))))).
fof(p2, axiom, ! [X] : ((noninvasive(X) => provides(X, spatialresolutionofbrains)))).
fof(p3, axiom, ! [X] : ((provides(X, spatialresolutionofbrains) => measure(X, brainactivity)))).
fof(p4, axiom, ! [X] : ((measure(X, brainactivity) => usedby(X, neuroscienceresearchers)))).
fof(p5, axiom, (measure(fmri, brainactivity) <~> noninvasive(fmri))).
fof(p6, axiom, neuroimagingtechnique(fmri)).
fof(extra1, axiom, ~((~((invasive(fmri) & usedby(fmri, neuroscienceresearchers))) => ~((noninvasive(fmri) | provides(fmri, spatialresolutionofbrains)))))).
