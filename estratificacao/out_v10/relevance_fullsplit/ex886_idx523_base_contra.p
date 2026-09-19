% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((iphone(X) => ~(standalonedesktop(X))))).
fof(p2, axiom, ! [X] : (((applemade(X) & cellphone(X)) => iphone(X)))).
fof(p3, axiom, ! [X] : (((phone(X) & with(X, a15bionicchip)) => (applemade(X) & cellphone(X))))).
fof(p4, axiom, ! [X] : ((((phone(X) & equippedwith(X, fourcoregpu)) & madeby(X, apple)) => (phone(X) & with(X, a15bionicchip))))).
fof(p5, axiom, (((phone(unannouncedhuaweiphone) & with(unannouncedhuaweiphone, a15bionicchip)) <~> ((phone(unannouncedhuaweiphone) & equippedwith(unannouncedhuaweiphone, fourcoregpu)) & madeby(unannouncedhuaweiphone, apple))) => ~(((phone(unannouncedhuaweiphone) & with(unannouncedhuaweiphone, a15bionicchip)) & standalonedesktop(unannouncedhuaweiphone))))).
fof(extra1, axiom, (~(((phone(unannouncedhuaweiphone) & equippedwith(unannouncedhuaweiphone, fourcoregpu)) & madebyapple(unannouncedhuaweiphone))))).
