% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, professionaltennisplayer(rafanadal)).
fof(p2, axiom, highwinratio(rafanadal)).
fof(p3, axiom, ! [X] : (((professionaltennisplayer(X) & highwinratio(X)) => inbig3(X)))).
fof(extra1, axiom, (inbig3(rafanadal))).
