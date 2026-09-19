% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ((event(ufcfightnight) & mixedmartial(ufcfightnight)) & heldin(ufcfightnight, sweden))).
fof(p2, axiom, scheduledtofight(sadollah, musoke, ufcfightnight)).
fof(p3, axiom, fight(sadollah, akiyama, ufcfightnight)).
fof(p4, axiom, fight(musoke, yakovlev, ufcfightnight)).
fof(p5, axiom, injuredat(jung, ufcfightnight)).
fof(p6, axiom, ! [X] : ((injuredat(X, ufcfightnight) => ~(fightin(X, ufcfightnight))))).
fof(extra1, axiom, ~(fight(nelson, story, ufcfightnight))).
