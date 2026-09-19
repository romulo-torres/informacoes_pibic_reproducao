% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (roadjunction(oxfordcircus) & connect(oxfordcircus, oxfordst, regentst))).
fof(p2, axiom, (in(oxfordst, london) & in(regentst, london))).
fof(p3, axiom, (designed(nash, construction) & on(construction, regentst))).
fof(p4, axiom, designed(nash, oxfordcircus)).
fof(p5, axiom, (architect(nash) & british(nash))).
fof(p6, axiom, ((entraceto(oxfordcircus, tubestation) & partof(tubestation, centralline)) & in(tubestation, num1900))).
fof(extra1, axiom, (! [X] : ((partof(X, centralline) => design(johnnash, X))))).
