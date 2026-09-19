% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((attend(X, wedding) => (gettingmarried(X) | ? [Y] : ((know(X, Y) & gettingmarried(Y))))))).
fof(p2, axiom, ! [X] : (((preteen(X) | youngchild(X)) => ~((gettingmarried(X) <~> ? [Y] : ((know(X, Y) & gettingmarried(Y)))))))).
fof(p3, axiom, ! [X] : ((? [Y] : (? [Z] : (((((~((X = Y)) & ~((X = Z))) & ~((Y = Z))) & enjoy(X, celebratinglifemilestoneevent, Y)) & enjoy(X, celebratinglifestoneevent, Z)))) => attend(X, wedding)))).
fof(p4, axiom, ! [X] : ((fondof(X, largegroupfunction) => ? [Y] : (? [Z] : (((((~((X = Y)) & ~((X = Z))) & ~((Y = Z))) & enjoy(X, celebratinglifemilestoneeventwith, Y)) & enjoy(X, celebratinglifestoneevent, Z))))))).
fof(p5, axiom, ! [X] : (((outgoing(X) & sprited(X)) => fondof(X, largegroupfunction)))).
fof(p6, axiom, (~(((preteen(carol) | youngchildren(carol)) & attend(carol, wedding))) => ~((gettingmarried(carol) | ? [Y] : ((know(carol, Y) & gettingmarried(Y))))))).
fof(extra1, axiom, ~((outgoing(carol) & sprited(carol)))).
