% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((atop3bestsellingvideogame(X) => multiplatform(X)))).
fof(p2, axiom, ! [X] : ((soldmorethan100millioncopies(X) => atop3bestsellingvideogame(X)))).
fof(p3, axiom, ? [X] : ((supportswindows(X) & agamedevelopedbynintendo(X)))).
fof(p4, axiom, ! [X] : ((multiplatform(X) => canbeplayedonawiderangeofdevices(X)))).
fof(p5, axiom, ~((developedbynintendo(pokemondiamond) | canbeplayedonawiderangeofdevices(pokemondiamond)))).
fof(extra1, axiom, ~(((game(pokemondiamond) & supportswindows(pokemondiamond)) <~> ((game(pokemondiamond) | soldmorethan100millioncopies(pokemondiamond)) => ((multiplatform(pokemondiamond) & (game(pokemondiamond) & atop3bestsellingvideogame(pokemondiamond))) <~> (~(multiplatform(pokemondiamond)) & ~((game(pokemondiamond) & atop3bestsellingvideogame(pokemondiamond))))))))).
