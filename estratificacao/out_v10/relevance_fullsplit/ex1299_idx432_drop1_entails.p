% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((havejobat(X, school) => onpayroll(X)))).
fof(p2, axiom, ! [X] : ((facultymember(X) => havejobat(X, school)))).
fof(p3, axiom, ! [X] : ((teach(X, student) => (facultymember(X) | teacher(X))))).
fof(p4, axiom, ! [X] : ((teacher(X) => have(X, student)))).
fof(p5, axiom, (teacher(nancy) => onpayroll(nancy))).
fof(p6, axiom, (~(teacher(nancy)) => ~(onpayroll(nancy)))).
fof(p7, axiom, teach(nancy, student)).
fof(extra1, axiom, ~((paidby(nancy, school) & have(nancy, student)))).
