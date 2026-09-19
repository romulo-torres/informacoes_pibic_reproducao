% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((robinsfriends(X) & practice(X, codingquestion)) => ~(studyingtogototobecome(X, medicalschool, doctor))))).
fof(p2, axiom, ! [X] : (((robinsfriends(X) & wanttoworkin(X, softwareengineeringindustry)) => practicecodingquestions(X)))).
fof(p3, axiom, ! [X] : ((((robinsfriends(X) & enjoy(X, healthcarefield)) & wanttohelp(X, peoplewithmedicalissue)) => studyingtogototobecome(X, medicalschool, doctor)))).
fof(p4, axiom, ! [X] : (((robinsfriends(X) & ? [Y] : (? [Z] : (((((((~((Y = Z)) & growupwith(X, Y)) & growupwith(X, Z)) & parentof(Y, X)) & parentof(Z, X)) & doctor(Y)) & doctor(Z))))) => (enjoyhealthcarefields(X) & wanttohelp(X, peoplewithmedicalissue))))).
fof(p5, axiom, ! [X] : (((robinsfriends(X) & studyhard(X)) => ? [Y] : (? [Z] : (((((((~((Y = Z)) & growupwith(X, Y)) & growupwith(X, Z)) & parentof(Y, X)) & parentof(Z, X)) & doctor(Y)) & doctor(Z))))))).
fof(p6, axiom, robinsfriends(mark)).
fof(p7, axiom, ~((((enjoy(x, healthcarefield) & wanttohelp(mark, peoplewithmedicalissues)) & ~(? [Y] : (? [Z] : (((((((~((Y = Z)) & growupwith(x, Y)) & growupwith(x, Z)) & parentof(Y, x)) & parentof(Z, x)) & doctor(Y)) & doctor(Z)))))) => (studyhard(mark) | ? [Y] : (? [Z] : (((((((~((Y = Z)) & growupwith(x, Y)) & growupwith(x, Z)) & parentof(Y, x)) & parentof(Z, x)) & doctor(Y)) & doctor(Z)))))))).
fof(extra1, axiom, ~((robinsfriends(mark) & studyhard(mark)))).
