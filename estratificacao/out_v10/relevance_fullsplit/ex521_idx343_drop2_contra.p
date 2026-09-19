% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((superhero(X) & american(X)) => (comefrom(X, dcuniverse) <~> comefrom(X, marveluniverse))))).
fof(p2, axiom, ~(comefrom(captainamerica, dcuniverse))).
fof(p3, axiom, ! [X] : ((((american(X) & toptenfavorite(X)) & superhero(X)) => speak(X, english)))).
fof(p4, axiom, ? [X] : ((superhero(X) => (speak(X, english) & speak(X, spanish))))).
fof(extra1, axiom, (~(speak(captainamerica, english)))).
