% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (frenchtelevision(videogag) & airweekly(videogag))).
fof(p2, axiom, airon(videogag, frenchbroadcastchanneltf1)).
fof(p3, axiom, (! [X] : ((((funny(X) & video(X)) & sendin(viewers, X, frenchbroadcastchanneltf1)) => airweekly(X))) & airon(videogag, x))).
fof(p4, axiom, ! [X] : (((video(X) & airon(videogag, X)) => in(X, french)))).
fof(extra1, axiom, (? [X] : ((sendin(viewers, X, frenchbroadcastchanneltf1) & english(X))))).
