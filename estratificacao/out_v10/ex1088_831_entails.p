% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((mindreading(X) & (brainreading(X) <~> braindecoding(X))))).
fof(p2, axiom, ! [X] : (((mindreading(X) & braindecoding(X)) => extractingfrom(X, information, boldsignals)))).
fof(p3, axiom, ! [X] : (((mindreading(X) & extractingfrom(X, information, boldsignals)) => uses(X, statisticalpatternanalysis)))).
fof(p4, axiom, ! [X] : ((novelwriting(X) => ~(uses(X, statisticalpatternanalysis))))).
fof(p5, axiom, ((mindreading(multivoxelpatternanalysis) & (~(uses(multivoxelpatternanalysis, statisticalpatternanalysis)) & brainreading(multivoxelpatternanalysis))) => (~(uses(multivoxelpatternanalysis, statisticalpatternanalysis)) & ~(braindecoding(multivoxelpatternanalysis))))).
fof(p6, axiom, mindreading(multivoxelpatternanalysis)).
fof(extra1, axiom, ~((~(uses(multivoxelpatternanalysis, statisticalpatternanalysis)) <~> writing(multivoxelpatternanalysis, anovel)))).
