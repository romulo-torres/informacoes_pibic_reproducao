% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (meegobased(wetab) & tabletcomputer(wetab))).
fof(p2, axiom, ! [X] : (announcedby(wetab, neofonie))).
fof(p3, axiom, (german(neofonie) & producer(neofonie))).
fof(p4, axiom, ! [X] : ((german(X) => (livein(X, german) <~> liveabroad(X))))).
fof(extra1, axiom, ((~(speak(neofonie, english)) & ~(speak(neofonie, german))))).
