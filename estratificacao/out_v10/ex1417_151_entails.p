% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((song(X) => ~(visual(X))))).
fof(p2, axiom, ! [X] : ((folksong(X) => song(X)))).
fof(p3, axiom, ! [X] : ((video(X) => visual(X)))).
fof(p4, axiom, ! [X] : ((movie(X) => video(X)))).
fof(p5, axiom, ! [X] : ((scifimovie(X) => movie(X)))).
fof(p6, axiom, scifimovie(inception)).
fof(p7, axiom, (~(folksong(mac)) & ~(scifimovie(mac)))).
fof(extra1, axiom, ~((video(inception) <~> folksong(inception)))).
