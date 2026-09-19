% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((linearfunction(X) => ~(nonconvexfunction(X))))).
fof(p2, axiom, ! [X] : ((function(X) => (nonconvexfunction(X) <~> convexfunction(X))))).
fof(p3, axiom, ! [X] : ((quasiconvexfunction(X) => realvaluedfunction(X)))).
fof(p4, axiom, ! [X] : ((convexfunction(X) => quasiconvexfunction(X)))).
fof(p5, axiom, function(maximumofquasiconvexfunction)).
fof(p6, axiom, (((function(maximumofquasiconvexfunction) & representon(maximumofquasiconvexfunction, straightline, coordinateplane)) | convexfunction(maximumofquasiconvexfunction)) | ~(nonconvexfunction(maximumofquasiconvexfunction)))).
fof(extra1, axiom, ~(~(realvaluedfunction(maximumofquasiconvexfunction)))).
