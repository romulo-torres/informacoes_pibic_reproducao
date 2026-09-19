% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, scheduledtofight(sadollah, musoke, ufcfightnight)).
fof(p2, axiom, fight(sadollah, akiyama, ufcfightnight)).
fof(p3, axiom, fight(musoke, yakovlev, ufcfightnight)).
fof(p4, axiom, injuredat(jung, ufcfightnight)).
fof(p5, axiom, ! [X] : ((injuredat(X, ufcfightnight) => ~(fightin(X, ufcfightnight))))).
fof(extra1, axiom, ~((event(ufcfightnight) & ~(fightin(jung, ufcfightnight))))).
