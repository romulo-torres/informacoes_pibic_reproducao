% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (song(hoorayhoorayitsaholiholiday) & hitallovereurope(hoorayhoorayitsaholiholiday))).
fof(p2, axiom, (song(hoorayhoorayitsaholiholiday) & ~(number1germansingle(hoorayhoorayitsaholiholiday)))).
fof(p3, axiom, ! [X] : ((peakbelowon(X, number1, germanchart) => ~(number1germansingle(X))))).
fof(extra1, axiom, ((song(hoorayhoorayitsaholiholiday) & number1germansingle(hoorayhoorayitsaholiholiday)))).
