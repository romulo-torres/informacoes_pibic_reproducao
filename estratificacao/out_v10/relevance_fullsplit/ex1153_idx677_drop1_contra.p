% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((soldmorethan100millioncopies(X) => atop3bestsellingvideogame(X)))).
fof(p2, axiom, ? [X] : ((supportswindows(X) & agamedevelopedbynintendo(X)))).
fof(p3, axiom, ! [X] : ((multiplatform(X) => canbeplayedonawiderangeofdevices(X)))).
fof(p4, axiom, ~((developedbynintendo(pokemondiamond) | canbeplayedonawiderangeofdevices(pokemondiamond)))).
fof(extra1, axiom, (((game(pokemondiamond) & supportswindows(pokemondiamond)) & (game(pokemondiamond) & soldmorethan100millioncopies(pokemondiamond))))).
