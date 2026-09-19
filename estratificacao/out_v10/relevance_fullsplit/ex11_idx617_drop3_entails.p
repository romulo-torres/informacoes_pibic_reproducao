% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (superhero(peterparker) <~> civilian(peterparker))).
fof(p2, axiom, destroyer(thehulk)).
fof(p3, axiom, (wakesup(thehulk) => breaks(thehulk, bridge))).
fof(p4, axiom, god(thor)).
fof(p5, axiom, (happy(thor) => breaks(thor, bridge))).
fof(p6, axiom, ! [X] : ((god(X) => ~(destroyer(X))))).
fof(p7, axiom, (superhero(peter) => wears(peter, uniform))).
fof(p8, axiom, ! [X] : (((destroyer(X) & breaks(X, bridge)) => ~(civilian(peter))))).
fof(p9, axiom, (happy(thor) => angry(thehulk))).
fof(extra1, axiom, ~((~(wakesup(thehulk)) => ~(happy(thor))))).
