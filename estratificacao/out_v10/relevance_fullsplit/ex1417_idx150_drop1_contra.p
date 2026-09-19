% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((folksong(X) => song(X)))).
fof(p2, axiom, ! [X] : ((video(X) => visual(X)))).
fof(p3, axiom, ! [X] : ((movie(X) => video(X)))).
fof(p4, axiom, ! [X] : ((scifimovie(X) => movie(X)))).
fof(p5, axiom, scifimovie(inception)).
fof(p6, axiom, (~(folksong(mac)) & ~(scifimovie(mac)))).
fof(extra1, axiom, ((video(inception) <~> folksong(inception)))).
