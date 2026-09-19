% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((workat(X, jessscompany) & gotospafrequently(X)) => ~((miserly(X) & needtosave(X, alargeportionofincome)))))).
fof(p2, axiom, ! [X] : ((workat(X, jessscompany) => ((miserly(X) & needtosave(X, alargeportionofincome)) <~> spendfrivolously(X, alotofmoney))))).
fof(p3, axiom, ! [X] : (((workat(X, jessscompany) & spendfrivolously(X, alotofmoney)) => (value(X, qualitymanufacturing) & value(X, luxuryitem))))).
fof(p4, axiom, ! [X] : ((((workat(X, jessscompany) & value(X, qualitymanufacturing)) & value(X, luxuryitem)) => enjoy(X, shopping, materialisticitem)))).
fof(p5, axiom, workat(thomas, jessscompany)).
fof(p6, axiom, (~((miserly(thomas) & needtosave(thomas, alargeportionofincome))) => ~((value(thomas, qualitymanufacturing) & value(thomas, luxuryitem))))).
fof(p7, axiom, ((value(thomas, qualitymanufacturing) & value(thomas, luxuryitem)) | ~((miserly(x) & needtosave(x, alargeportionofincome))))).
fof(extra1, axiom, (spendfrivolously(thomas, alotofmoney))).
