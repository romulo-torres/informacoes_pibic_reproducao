% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((((model(X) & summarization(X)) & onlyuseinputdocument(X)) => faithful(X)))).
fof(p2, axiom, ! [X] : (((model(X) & extractive(X)) => (model(X) & summarization(X))))).
fof(p3, axiom, ! [X] : (((model(X) & extractive(X)) => onlyuseinputdocument(X)))).
fof(extra1, axiom, (? [X] : (((model(X) & extractive(X)) & ~(faithful(X)))))).
