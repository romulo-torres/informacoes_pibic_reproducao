% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((philosopher(X) => reason(X)))).
fof(p2, axiom, ? [X] : ((sophist(X) & reason(X)))).
fof(p3, axiom, ! [X] : ((reason(X) => candistinguishfrom(X, truth, falsehood)))).
fof(p4, axiom, ! [X] : ((candistinguishfrom(X, truth, falsehood) => ~(morallyperfect(X))))).
fof(p5, axiom, morallyperfect(theisticgod)).
fof(extra1, axiom, ((philosopher(theisticgod) => ~(sophist(theisticgod))))).
