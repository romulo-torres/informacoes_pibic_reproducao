% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((((customer(X) & in(X, jamesfamily)) & subscribedto(X, amcalist)) => eligibleforthreefreemovieseveryweekwithoutadditionalfees(X)))).
fof(p2, axiom, ? [X] : (? [Y] : (((((((customer(X) & in(X, jamesfamily)) & gotoeveryweek(X, cinema)) & ~((X = Y))) & customer(Y)) & in(Y, jamesfamily)) & gotoeveryweek(Y, cinema))))).
fof(p3, axiom, ! [X] : (((customer(X) & in(X, jamesfamily)) & (subscribedto(X, amcalist) | subscribedto(X, hbo))))).
fof(p4, axiom, ! [X] : ((((customer(X) & in(X, jamesfamily)) & prefer(X, tvseries)) => ~(watchin(X, tv, cinema))))).
fof(p5, axiom, ! [X] : ((((customer(X) & in(X, jamesfamily)) & subscribedto(X, hbo)) => prefer(X, tvseries)))).
fof(p6, axiom, ((customer(lily) & in(lily, jamesfamily)) & watchin(lily, tv, cinema))).
fof(extra1, axiom, ~((gotoeveryweek(lily, cinema) | eligibleforthreefreemovieswithoutadditionalfees(lily)))).
