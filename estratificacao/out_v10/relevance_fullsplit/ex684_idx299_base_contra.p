% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((student(X) & learningpiano(X)) => can(X, strike, rightnote)))).
fof(p2, axiom, ! [X] : (((student(X) & can(X, strike, rightnote)) => can(X, gettherhythmright)))).
fof(p3, axiom, ! [X] : (((student(X) & can(X, gettherhythmright)) => start(X, workingoncoordinationbetweentheleftandrighthands)))).
fof(p4, axiom, ! [X] : (((student(X) & start(X, workingoncoordinationbetweentheleftandrighthands)) => (become(X, goodatcoordination) <~> find(X, coordinationchallenging))))).
fof(p5, axiom, (((can(john, gettherhythmright) & can(john, gettherhythmright)) & become(john, goodatcoordination)) => putemotioninto(john, hisplaying))).
fof(p6, axiom, (student(john) & learningpiano(john))).
fof(p7, axiom, ~(find(john, coordinationchallenging))).
fof(extra1, axiom, (putemotioninto(john, hisplaying))).
