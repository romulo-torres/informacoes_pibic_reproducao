% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((in(X, lovecity) => (considersmostimportantlovelanguage(X, physicaltouch) | considersmostimportantlovelanguage(X, wordofaffirmation))))).
fof(p2, axiom, ! [X] : (((considersmostimportantlovelanguage(X, physicaltouch) & in(X, lovecity)) => goodwith(X, pet)))).
fof(p3, axiom, ! [X] : (((goodwith(X, pet) & in(X, lovecity)) => ~(scaredof(X, animal))))).
fof(p4, axiom, ! [X] : ((in(X, lovecity) => (scaredof(X, animal) | loves(X, animal))))).
fof(p5, axiom, ((considersmostimportantlovelanguage(adam, physicaltouch) <~> loves(adam, animal)) & in(adam, lovecity))).
fof(extra1, axiom, (scaredof(adam, animal))).
