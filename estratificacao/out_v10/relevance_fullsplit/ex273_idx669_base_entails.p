% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (((japanese(koeitecmo) & videogameholdingcompany(koeitecmo)) & animeholdingcompany(koeitecmo)) & holdingcompany(x))).
fof(p2, axiom, ! [X] : ((holdingcompany(X) => ? [Y] : ((company(Y) & holds(X, Y)))))).
fof(p3, axiom, ((disbandsin(tecmo, japan) & survives(koei)) & renames(koei))).
fof(p4, axiom, ! [X] : ((videogameholdingcompany(X) => holdingcompany(X)))).
fof(extra1, axiom, ~(? [X] : ((company(X) & holds(koeitecmo, X))))).
