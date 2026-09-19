% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((leetcodeproblems(X) & easy(X)) => ~(haveanacratelowerthan(X, percent20))))).
fof(p2, axiom, ! [X] : (((leetcodeproblems(X) & recommendedto(X, novices)) => easy(X)))).
fof(p3, axiom, ! [X] : ((leetcodeproblems(X) => (haveanacratelowerthan(X, percent20) <~> starredbymorethan(X, num1000))))).
fof(p4, axiom, ! [X] : (((leetcodeproblems(X) & hard(X)) => starredbymorethan(X, num1000)))).
fof(p5, axiom, ! [X] : (((leetcodeproblems(X) & publishedafter(X, yr2022)) => ~(starredbymorethan(X, num1000))))).
fof(p6, axiom, (~((recommendedto(twosum, novices) & hard(twosum))) & leetcodeproblems(twosum))).
fof(p7, axiom, (~((starredbymorethan(foursum, num1000) <~> publishedafter(foursum, yr2022))) & leetcodeproblems(twosum))).
fof(extra1, axiom, ((leetcodeproblems(twosum) & easy(twosum)))).
