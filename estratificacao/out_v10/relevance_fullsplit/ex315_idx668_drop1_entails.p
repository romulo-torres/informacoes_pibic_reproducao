% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ((foundin(palstave, northerneurope) | foundin(palstave, westerneurope)) | (foundin(palstave, southwesterneurope) & castin(palstave, molds)))).
fof(p2, axiom, (archeologist(johnevans) & popularize(johnevans, termpalstave))).
fof(p3, axiom, (~(axe(paalstab)) & diggingshovel(paalstab))).
fof(extra1, axiom, ~(! [X] : (! [Y] : ((archeologist(X) => ~(popularize(X, Y))))))).
