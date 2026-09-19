% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ((cricketeer(royrichardson) & playsfor(royrichardson, sintmaarten)) & constituentcountry(sintmaarten))).
fof(p2, axiom, ((righthanded(royrichardson) & batsman(royrichardson)) & mediumpacebowler(royrichardson))).
fof(p3, axiom, oldatdebut(royrichardson)).
fof(p4, axiom, dismisses(shervillehuggins, royrichardson)).
fof(extra1, axiom, (! [X] : (((righthanded(X) & mediumpacebowler(X)) => ~(playedfor(X, sintmaarten)))))).
