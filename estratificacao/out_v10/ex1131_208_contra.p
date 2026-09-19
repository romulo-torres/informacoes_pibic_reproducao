% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((performat(X, newhavensymphonyorchestra) & touringmusician(X)) => ~(permanentmemberof(X, theorchestra))))).
fof(p2, axiom, ! [X] : ((performat(X, newhavensymphonyorchestra) => (permanentmemberof(X, theorchestra) | havetemporaryroleat(X, theorchestra))))).
fof(p3, axiom, ! [X] : (((performat(X, newhavensymphonyorchestra) & touringmusicians(X)) => havetemporaryroleat(X, theorchestra)))).
fof(p4, axiom, ! [X] : (((performat(X, newhavensymphonyorchestra) & havetemporaryroleat(X, theorchestra)) => interestingsoloist(X)))).
fof(p5, axiom, ! [X] : (((performat(X, newhavensymphonyorchestra) & interestingsoloist(X)) => capableofattractingaudiences(X)))).
fof(p6, axiom, performat(ryan, newhavensymphonyorchestra)).
fof(p7, axiom, ((interestingsoloist(ryan) & havetemporaryroleat(ryan, theorchestra)) => ~((touringmusician(ryan) <~> capableofattractingaudiences(ryan))))).
fof(extra1, axiom, ((permanentmemberof(ryan, orchestra) <~> touringmusician(ryan)))).
