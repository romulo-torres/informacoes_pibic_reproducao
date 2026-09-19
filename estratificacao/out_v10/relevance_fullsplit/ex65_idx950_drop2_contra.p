% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((subscribedto(X, amcalist) => eligibleforthreefreemovies(X)))).
fof(p2, axiom, ! [X] : ((prefer(X, tvseries) => ~(watchtvin(X, cinemas))))).
fof(p3, axiom, watchtvin(james, cinemas)).
fof(p4, axiom, subscribedto(james, amcalist)).
fof(p5, axiom, prefer(peter, tvseries)).
fof(extra1, axiom, (~(watchtvin(peter, cinemas)))).
