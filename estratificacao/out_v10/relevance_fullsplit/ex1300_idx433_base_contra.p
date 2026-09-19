% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((onpayroll(X) => paidby(X, school)))).
fof(p2, axiom, ! [X] : ((havejobat(X, school) => onpayroll(X)))).
fof(p3, axiom, ! [X] : ((facultymember(X) => havejobat(X, school)))).
fof(p4, axiom, ! [X] : ((teach(X, student) => (facultymember(X) | teacher(X))))).
fof(p5, axiom, ! [X] : ((teacher(X) => have(X, student)))).
fof(p6, axiom, (teacher(nancy) => onpayroll(nancy))).
fof(p7, axiom, (~(teacher(nancy)) => ~(onpayroll(nancy)))).
fof(p8, axiom, teach(nancy, student)).
fof(extra1, axiom, ((~(paidby(nancy, school)) | ~(have(nancy, student))))).
