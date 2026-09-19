% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (usnavyship(theusslyon) & involvedin(theusslyon, wwii))).
fof(p2, axiom, ! [X] : ((involvedin(X, wwii) => (currentlydecommissioned(X) | in(X, museum))))).
fof(extra1, axiom, (currentlydecommissioned(theusslyon))).
