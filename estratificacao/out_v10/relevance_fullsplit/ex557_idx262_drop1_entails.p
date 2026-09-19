% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ? [X] : (((administer(ets, X) & internationaltest(X)) & (((toefl(X) | toeic(X)) | gre(X)) | subjecttest(X))))).
fof(p2, axiom, ? [X] : ((develop(ets, X) & associatedwith(X, entrytouseducationinstitution)))).
fof(p3, axiom, ? [X] : (((develop(ets, X) & statewideassesment(X)) & usedfor(X, accountabilitytesting)))).
fof(extra1, axiom, ~(? [X] : (? [Y] : ((((develop(ets, X) & statewideassesment(X)) & develop(ets, Y)) & associatedwith(Y, entrytouseducationinstitution)))))).
