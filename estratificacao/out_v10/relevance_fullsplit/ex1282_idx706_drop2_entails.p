% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((lazy(X) => unproductive(X)))).
fof(p2, axiom, ! [X] : ((sloth(X) => lazy(X)))).
fof(p3, axiom, ? [X] : ((animal(X) & sloth(X)))).
fof(p4, axiom, (~(energetic(sid)) & ~(sloth(sid)))).
fof(extra1, axiom, ~(((animal(sid) <~> unproductive(sid)) => ~(energetic(sid))))).
