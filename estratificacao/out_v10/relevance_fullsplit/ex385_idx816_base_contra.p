% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (((awardedto(turingaward, donaldknuth) & awardedto(turingaward, marvinminsky)) & awardedto(turingaward, richardhamming)) & awardedto(turingaward, johnmccarthy))).
fof(p2, axiom, contributedto(donaldknuth, analysisofalgorithms)).
fof(p3, axiom, contributedto(marvinminsky, artificialintelligence)).
fof(p4, axiom, contributedto(richardhamming, numericalmethods)).
fof(p5, axiom, contributedto(johnmccarthy, artificialintelligence)).
fof(extra1, axiom, (! [X] : ((awardedto(turingaward, X) => ~(contributedto(X, numericalmethods)))))).
