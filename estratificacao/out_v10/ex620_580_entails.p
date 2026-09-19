% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (play(maya, violin) => ~(caninjure(maya, fingers)))).
fof(p2, axiom, ! [X] : ((volleyballplayer(X) => ((caninjure(ankles) & caninjure(fingers)) & caninjure(shoulder))))).
fof(p3, axiom, volleyballplayer(maya)).
fof(extra1, axiom, ~(~(play(maya, violin)))).
