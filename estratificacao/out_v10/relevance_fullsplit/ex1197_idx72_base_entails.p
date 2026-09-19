% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((at(X, businessconference) => (investor(X) <~> entrepreneur(X))))).
fof(p2, axiom, ! [X] : (((at(X, businessconference) & enjoy(X, opportunityofstartingownbusiness)) => ~(prefer(X, plannedeconomy))))).
fof(p3, axiom, ! [X] : (((at(X, businessconference) & entrepreneur(X)) => enjoy(X, opportunityofstartingownbusiness)))).
fof(p4, axiom, ! [X] : (((at(X, businessconference) & enjoy(X, stateownershipofmeansofproduction)) => prefer(X, plannedeconomy)))).
fof(p5, axiom, ! [X] : (((at(X, businessconference) & ardentcommunist(X)) => prefer(X, stateownershipofmeansofproduction)))).
fof(p6, axiom, (at(ho, businessconference) & prefer(ho, stateownershipofmeansofproduction))).
fof(extra1, axiom, ~(~(ardentcommunist(ho)))).
