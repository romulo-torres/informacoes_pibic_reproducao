% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((subscribedto(X, amcalist) => eligibleforthreefreemovies(X)))).
fof(p2, axiom, ? [X] : (cinemaeveryweek(X))).
fof(p3, axiom, ! [X] : ((prefer(X, tvseries) => ~(watchtvin(X, cinemas))))).
fof(p4, axiom, watchtvin(james, cinemas)).
fof(p5, axiom, subscribedto(james, amcalist)).
fof(p6, axiom, prefer(peter, tvseries)).
fof(extra1, axiom, ~(cinemaeveryweek(james))).
