% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (superhero(peterparker) <~> civilian(peterparker))).
fof(p2, axiom, destroyer(thehulk)).
fof(p3, axiom, (angry(thehulk) => wakesup(thehulk))).
fof(p4, axiom, (wakesup(thehulk) => breaks(thehulk, bridge))).
fof(p5, axiom, god(thor)).
fof(p6, axiom, (happy(thor) => breaks(thor, bridge))).
fof(p7, axiom, ! [X] : ((god(X) => ~(destroyer(X))))).
fof(p8, axiom, (superhero(peter) => wears(peter, uniform))).
fof(p9, axiom, ! [X] : (((destroyer(X) & breaks(X, bridge)) => ~(civilian(peter))))).
fof(p10, axiom, (happy(thor) => angry(thehulk))).
fof(p11, axiom, noise_p_972423195(noise_c_972423195)).
fof(extra1, axiom, ~((~(happy(thor)) => ~(breaks(thor, bridge))))).
