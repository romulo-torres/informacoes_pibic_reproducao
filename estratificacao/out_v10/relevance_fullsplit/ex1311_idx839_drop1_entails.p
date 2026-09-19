% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ? [X] : ((sophist(X) & reason(X)))).
fof(p2, axiom, ! [X] : ((reason(X) => candistinguishfrom(X, truth, falsehood)))).
fof(p3, axiom, ! [X] : ((candistinguishfrom(X, truth, falsehood) => ~(morallyperfect(X))))).
fof(p4, axiom, morallyperfect(theisticgod)).
fof(extra1, axiom, ~((sophist(theisticgod) & philosopher(theisticgod)))).
