% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((function(X) & representon(X, straightline, coordinateplane)) => linearfunction(X)))).
fof(p2, axiom, ! [X] : ((linearfunction(X) => ~(nonconvexfunction(X))))).
fof(p3, axiom, ! [X] : ((function(X) => (nonconvexfunction(X) <~> convexfunction(X))))).
fof(p4, axiom, ! [X] : ((quasiconvexfunction(X) => realvaluedfunction(X)))).
fof(p5, axiom, ! [X] : ((convexfunction(X) => quasiconvexfunction(X)))).
fof(p6, axiom, function(maximumofquasiconvexfunction)).
fof(p7, axiom, (((function(maximumofquasiconvexfunction) & representon(maximumofquasiconvexfunction, straightline, coordinateplane)) | convexfunction(maximumofquasiconvexfunction)) | ~(nonconvexfunction(maximumofquasiconvexfunction)))).
fof(extra1, axiom, ((function(maximumofquasiconvexfunction) & representon(maximumofquasiconvexfunction, straightline, coordinateplane)))).
