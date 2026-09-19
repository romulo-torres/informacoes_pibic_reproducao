% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((model(X) & extractive(X)) => (model(X) & summarization(X))))).
fof(p2, axiom, ! [X] : (((model(X) & extractive(X)) => onlyuseinputdocument(X)))).
fof(extra1, axiom, ~(! [X] : (((model(X) & extractive(X)) => faithful(X))))).
