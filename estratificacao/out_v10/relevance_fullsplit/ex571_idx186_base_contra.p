% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : (((wildfeed(X) & unannounced(X)) & program(X)))).
fof(p2, axiom, ! [X] : ((wildfeed(X) => ((sportingevent(X) | news(X)) | syndicatedshow(X))))).
fof(p3, axiom, ! [X] : ((prerecorded(X) => copyrightviolation(X)))).
fof(p4, axiom, ! [X] : ((program(X) => prerecorded(X)))).
fof(extra1, axiom, (? [X] : ((syndicatedshows(X) & copyrightviolation(X))))).
