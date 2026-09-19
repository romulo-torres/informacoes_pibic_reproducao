% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((athlete(X) => ~(neverexercises(X))))).
fof(p2, axiom, ! [X] : ((professionalbasketballplayer(X) => athlete(X)))).
fof(p3, axiom, ! [X] : ((nbaplayer(X) => professionalbasketballplayer(X)))).
fof(p4, axiom, ! [X] : ((knicksplayer(X) => nbaplayer(X)))).
fof(p5, axiom, ~((professionalbasketballplayer(jim) <~> neverexercises(jim)))).
fof(extra1, axiom, ~(~(knicksplayer(jim)))).
