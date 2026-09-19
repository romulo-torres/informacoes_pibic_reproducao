% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((noninvasive(X) => provides(X, spatialresolutionofbrains)))).
fof(p2, axiom, ! [X] : ((provides(X, spatialresolutionofbrains) => measure(X, brainactivity)))).
fof(p3, axiom, ! [X] : ((measure(X, brainactivity) => usedby(X, neuroscienceresearchers)))).
fof(p4, axiom, (measure(fmri, brainactivity) <~> noninvasive(fmri))).
fof(p5, axiom, neuroimagingtechnique(fmri)).
fof(extra1, axiom, ~((~((invasive(fmri) & usedby(fmri, neuroscienceresearchers))) => ~((noninvasive(fmri) | provides(fmri, spatialresolutionofbrains)))))).
