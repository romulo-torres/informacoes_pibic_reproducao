% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((disposable(X) & product(X)) => ~(helpslowdown(X, globalwarming))))).
fof(p2, axiom, ! [X] : (((ecofriendly(X) & brand(X)) => help(X, slowdownglobalwarming)))).
fof(p3, axiom, ! [X] : (((sustainable(X) & fashionbrand(X)) => (ecofriendly(X) & brand(X))))).
fof(p4, axiom, ! [X] : (((fastfashion(X) & product(X)) => (disposable(X) & product(X))))).
fof(p5, axiom, (~(helpslowdown(reformation, globalwarming)) => ((ecofriendly(reformation) & brand(reformation)) | (sustainable(reformation) & fashionbrand(reformation))))).
fof(extra1, axiom, ~(((disposable(reformation) & product(reformation)) => (fastfashion(reformation) & product(reformation))))).
