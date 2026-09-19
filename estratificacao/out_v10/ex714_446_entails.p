% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((sportscar(X) => ~(intendedtobedrivenat(X, moderatespeed))))).
fof(p2, axiom, ! [X] : ((designedfor(X, familyuse) => intendedtobedrivenat(X, moderatespeed)))).
fof(extra1, axiom, ~(! [X] : ((sportscar(X) => ~(for(X, familyuse)))))).
