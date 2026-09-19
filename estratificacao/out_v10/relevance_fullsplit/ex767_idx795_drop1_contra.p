% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((whitecollarworker(X) => entitledto(X, federalminimumwage)))).
fof(p2, axiom, ! [X] : ((lawyer(X) => whitecollarworker(X)))).
fof(p3, axiom, ! [X] : ((advocate(X) => lawyer(X)))).
fof(p4, axiom, ~((lawyer(mary) <~> tippedemployee(mary)))).
fof(extra1, axiom, ((advocate(mary) <~> tippedemployee(mary)))).
