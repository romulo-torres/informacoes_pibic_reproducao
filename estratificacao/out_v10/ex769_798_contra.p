% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((tippedemployee(X) => ~(entitledto(X, federalminimumwage))))).
fof(p2, axiom, ! [X] : ((whitecollarworker(X) => entitledto(X, federalminimumwage)))).
fof(p3, axiom, ! [X] : ((lawyer(X) => whitecollarworker(X)))).
fof(p4, axiom, ! [X] : ((advocate(X) => lawyer(X)))).
fof(p5, axiom, ~((lawyer(mary) <~> tippedemployee(mary)))).
fof(extra1, axiom, (((advocate(mary) <~> tippedemployee(mary)) => advocate(mary)))).
