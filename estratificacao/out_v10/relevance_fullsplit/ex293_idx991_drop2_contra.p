% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (((bornin(deborahwallace, scotland) & actress(deborahwallace)) & playwright(deborahwallace)) & producer(deborahwallace))).
fof(p2, axiom, (((((play(homesick) & writtenby(homesick, deborahwallace)) & play(psyche)) & writtenby(psyche, deborahwallace)) & play(thevoid)) & writtenby(thevoid, deborahwallace))).
fof(p3, axiom, coproduce(deborahwallace, gasland)).
fof(extra1, axiom, (! [X] : (((play(X) & writtenby(X, deborahwallace)) => ~(basedon(X, lifeofjamesmirandabarry)))))).
