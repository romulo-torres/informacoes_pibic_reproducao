% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((brainstudy(X) => (blockdesign(X) <~> event_relateddesign(X))))).
fof(p2, axiom, ! [X] : (((brainstudy(X) & eventrelateddesign(X)) => brainimageacquisition(X)))).
fof(p3, axiom, ! [X] : (((brainstudy(X) & brainimageacquisition(X)) => precededby(X, dataprocessing)))).
fof(p4, axiom, ! [X] : (((brainstudy(X) & precededby(X, dataprocessing)) => ~(analyze(X, data))))).
fof(p5, axiom, (brainstudy(picturememory) & ~((eventrelateddesign(picturememory) <~> analyzingdata(picturememory))))).
fof(extra1, axiom, (precededby(picturememory, dataprocessing))).
