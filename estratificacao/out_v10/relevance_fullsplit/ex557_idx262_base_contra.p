% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : (? [Y] : ((((((((develop(ets, X) & develop(ets, Y)) & standardizedtest(X)) & standardizedtest(Y)) & in(X, unitedstate)) & in(Y, unitedstate)) & for(X, k12andhighereducation)) & for(Y, k12andhighereducation))))).
fof(p2, axiom, ? [X] : (((administer(ets, X) & internationaltest(X)) & (((toefl(X) | toeic(X)) | gre(X)) | subjecttest(X))))).
fof(p3, axiom, ? [X] : ((develop(ets, X) & associatedwith(X, entrytouseducationinstitution)))).
fof(p4, axiom, ? [X] : (((develop(ets, X) & statewideassesment(X)) & usedfor(X, accountabilitytesting)))).
fof(extra1, axiom, (? [X] : (? [Y] : ((((develop(ets, X) & statewideassesment(X)) & develop(ets, Y)) & associatedwith(Y, entrytouseducationinstitution)))))).
