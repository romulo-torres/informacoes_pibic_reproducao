% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((emilysfriend(X) & publish(X, journal)) => ~(workin(X, entertainmentindustry))))).
fof(p2, axiom, ! [X] : (((emilysfriend(X) & awardwinningnovelist(X)) => publish(X, journal)))).
fof(p3, axiom, ! [X] : ((emilysfriend(X) => (workin(X, entertainmentindustry) | highlyacclaimedin(X, theirprofession))))).
fof(p4, axiom, ! [X] : (((emilysfriend(X) & highlyacclaimedin(X, theirprofession)) => ? [Y] : ((((holdat(X, Y, workplace) & tenured(Y)) & highranking(Y)) & position(Y)))))).
fof(p5, axiom, ! [X] : (((emilysfriend(X) & highlyacclaimedin(X, theirprofession)) => (receivefrom(X, glowingfeedback, colleague) & receivefrom(X, glowingrecommendation, colleague))))).
fof(p6, axiom, emilysfriends(taylor)).
fof(p7, axiom, ~((highlyacclaimedin(taylor, theirprofession) & ? [Y] : ((((holdat(taylor, Y, workplace) & tenured(Y)) & highranking(Y)) & position(Y)))))).
fof(extra1, axiom, ~((emilysfriends(taylor) & ? [Y] : ((((holdat(taylor, Y, workplace) & tenured(Y)) & highranking(Y)) & position(Y)))))).
