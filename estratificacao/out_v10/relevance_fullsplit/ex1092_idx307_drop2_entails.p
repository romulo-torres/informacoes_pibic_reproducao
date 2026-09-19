% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((in(X, lovecity) => (considersmostimportantlovelanguage(X, physicaltouch) | considersmostimportantlovelanguage(X, wordofaffirmation))))).
fof(p2, axiom, ! [X] : (((goodwith(X, pet) & in(X, lovecity)) => ~(scaredof(X, animal))))).
fof(p3, axiom, ! [X] : ((in(X, lovecity) => (scaredof(X, animal) | loves(X, animal))))).
fof(p4, axiom, ((considersmostimportantlovelanguage(adam, physicaltouch) <~> loves(adam, animal)) & in(adam, lovecity))).
fof(extra1, axiom, ~((considersmostimportantlovelanguage(adam, physicaltouch) & considersmostimportantlovelanguage(adam, wordofaffirmation)))).
