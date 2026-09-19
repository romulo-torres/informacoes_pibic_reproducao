% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((planet(X) & in(X, solarsystem)) => ~(relyontogenerate(X, nuclearfusion, light))))).
fof(p2, axiom, ! [X] : (((star(X) & in(X, solarsystem)) => relyontogenerate(X, nuclearfusion, light)))).
fof(p3, axiom, ! [X] : ((((celestialbody(X) & in(X, solarsystem)) & greaterthan(X, solarmass, c_0point08)) => star(X)))).
fof(p4, axiom, ! [X] : (((((celestialbody(X) & in(X, solarsystem)) & ? [Y] : (((orbitof(Y, X) & clear(X, Y)) & debrisfree(Y)))) & nearlysphericalshape(X, gravity)) => planet(X)))).
fof(p5, axiom, (((((celestialbody(europa) & in(europa, solarsystem)) & ? [Y] : (((orbitof(Y, x) & clear(x, Y)) & debrisfree(Y)))) & nearlysphericalshape(europa, gravity)) | relyontogenerate(europa, nuclearfusion, light)) => (celestialbody(europa) & in(europa, solarsystem)))).
fof(extra1, axiom, (((celestialbody(europa) & in(europa, solarsystem)) & greaterthan(europa, solarmass, c_0_08)))).
