% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, bornin(rafanadal, mallorca)).
fof(p2, axiom, professionaltennisplayer(rafanadal)).
fof(p3, axiom, highwinratio(rafanadal)).
fof(p4, axiom, ! [X] : (((professionaltennisplayer(X) & highwinratio(X)) => inbig3(X)))).
fof(extra1, axiom, ~(~(bornin(rafanadal, mallorca)))).
