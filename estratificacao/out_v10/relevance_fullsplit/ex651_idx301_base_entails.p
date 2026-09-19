% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (formerswimmer(barbaraannmarshall) & formerworldrecordholder(barbaraannmarshall))).
fof(p2, axiom, participatedin(barbaraannmarshall, c_1972summerolympics)).
fof(p3, axiom, homecountry(barbaraannmarshall, unitedstates)).
fof(p4, axiom, ! [X] : (? [Y] : (((participatedin(X, c_1972summerolympics) & homecountry(X, Y)) => represented(X, Y))))).
fof(p5, axiom, participatedin(barbaraannmarshall, preliminaryheatfreestylerelay)).
fof(p6, axiom, ~(participatedin(barbaraannmarshall, finalheatfreestylerelay))).
fof(p7, axiom, ! [X] : ((((participatedin(X, c_1972summerolympics) & relayswimmer(X)) & ~(participatedin(X, finalheatfreestylerelay))) <=> ~(recieved(X, medal))))).
fof(extra1, axiom, ~(represented(barbaraannmarshall, unitedstates))).
