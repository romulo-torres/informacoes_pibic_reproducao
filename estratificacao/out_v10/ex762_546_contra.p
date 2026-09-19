% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((videogame(X) & releasedby(X, nintendo)) => ~(support(X, ps4))))).
fof(p2, axiom, ! [X] : (((videogame(X) & in(X, pokemonseries)) => releasedby(X, nintendo)))).
fof(p3, axiom, ! [X] : (((videogame(X) & in(X, fifaseries)) => support(X, ps4)))).
fof(p4, axiom, ! [X] : ((((videogame(X) & simulate(X, onlinesoccer)) & use(X, licensedplayer)) => in(X, fifaseries)))).
fof(p5, axiom, ((videogame(belionel) & in(belionel, pokemonseries)) | (simulate(belionel, onlinesoccer) & use(belionel, licensedplayer)))).
fof(extra1, axiom, (((videogame(belionel) & fifaseries(belionel)) <~> support(belionel, ps4)))).
