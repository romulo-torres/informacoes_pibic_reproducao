% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((wildfeed(X) => ((sportingevent(X) | news(X)) | syndicatedshow(X))))).
fof(p2, axiom, ! [X] : ((prerecorded(X) => copyrightviolation(X)))).
fof(p3, axiom, ! [X] : ((program(X) => prerecorded(X)))).
fof(extra1, axiom, (? [X] : ((wildfeed(X) & copyrightviolation(X))))).
