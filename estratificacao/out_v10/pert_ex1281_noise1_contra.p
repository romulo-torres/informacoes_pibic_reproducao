% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((lazy(X) => unproductive(X)))).
fof(p2, axiom, ! [X] : ((unproductive(X) => ~(energetic(X))))).
fof(p3, axiom, ! [X] : ((sloth(X) => lazy(X)))).
fof(p4, axiom, ? [X] : ((animal(X) & sloth(X)))).
fof(p5, axiom, (~(energetic(sid)) & ~(sloth(sid)))).
fof(p6, axiom, noise_p_912170735(noise_c_912170735)).
fof(extra1, axiom, ((energetic(sid) & animal(sid)))).
