% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((((soccerplayer(X) & useefficiently(X, leftfoot)) & useefficiently(X, rightfoot)) => topsoccerplayer(X)))).
fof(p2, axiom, ! [X] : (((soccerplayer(X) & scoreusing(X, manygoals, leftfoot)) => useefficiently(X, leftfoot)))).
fof(p3, axiom, ! [X] : (((soccerplayer(X) & scoreusing(X, manygoals, rightfoot)) => useefficiently(X, rightfoot)))).
fof(p4, axiom, soccerplayer(ronaldo)).
fof(p5, axiom, useefficiently(ronaldo, rightfoot)).
fof(p6, axiom, scoreusing(ronaldo, manygoals, leftfoot)).
fof(extra1, axiom, (~(topsoccerplayer(ronaldo)))).
