% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ((ownedby(sat, collegeboard) & developedby(sat, collegeboard)) & ~(? [Y] : ((~((Y = collegeboard)) & (ownedby(sat, Y) | developedby(sat, Y))))))).
fof(p2, axiom, intendedtoassess(sat, studentsreadinessforcollege)).
fof(p3, axiom, originallydesignedtobealignedwith(sat, highschoolcurricula)).
fof(p4, axiom, adjustmentmadein(sat, num2016, toalignwithhighschoolcurriculum)).
fof(extra1, axiom, ~((ownedby(sat, collegeboard) & ownedby(sat, otherthirdparties)))).
