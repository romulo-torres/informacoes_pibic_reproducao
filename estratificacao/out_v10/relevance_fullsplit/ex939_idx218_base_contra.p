% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((believein(X, santaclaus) <~> thinkmadeup(X, santaclaus)))).
fof(p2, axiom, ! [X] : ((believein(X, santaclaus) => expect(X, present, christmasmorning)))).
fof(p3, axiom, ! [X] : ((thinkmadeup(X, santaclaus) => wouldbesurprisedtoseein(X, santaclaus, house)))).
fof(p4, axiom, ! [X] : ((expect(X, present, christmasmorning) => excitedfor(X, christmas)))).
fof(p5, axiom, ! [X] : ((wouldbesurprisedtoseein(X, santaclaus, house) => ~(leaveout(X, cookies))))).
fof(p6, axiom, ~(((expect(marcy, present, christmasmorning) & excitedfor(marcy, christmas)) & believein(marcy, santaclaus)))).
fof(extra1, axiom, ((believein(marcy, santaclaus) <~> leaveout(marcy, cookies)))).
