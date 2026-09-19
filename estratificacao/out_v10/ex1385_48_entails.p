% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((((socialmedia(X) & application(X)) & contain(X, chatfeature)) => software(X)))).
fof(p2, axiom, ! [X] : ((((socialmedia(X) & application(X)) & allowtosendto(X, user, message)) => contain(X, chatfeature)))).
fof(p3, axiom, ! [X] : (((socialmedia(X) & application(X)) => (contain(X, chatfeature) | contain(X, videofeature))))).
fof(p4, axiom, ! [X] : ((((socialmedia(X) & application(X)) & contain(X, videofeature)) => allow(X, user, uploadvideo)))).
fof(p5, axiom, ! [X] : ((((socialmedia(X) & application(X)) & software(X)) => computerprogram(X)))).
fof(p6, axiom, ! [X] : ((((socialmedia(X) & application(X)) & have(X, highengagementmetric)) => addictive(X)))).
fof(p7, axiom, ! [X] : ((((socialmedia(X) & application(X)) & addictive(X)) => ~(idealfor(X, preteen))))).
fof(p8, axiom, ((socialmedia(tiktok) & application(tiktok)) & ~(idealfor(tiktok, preteen)))).
fof(extra1, axiom, ~(computerprogram(tiktok))).
