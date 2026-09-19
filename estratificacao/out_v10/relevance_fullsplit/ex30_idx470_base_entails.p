% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ((americanpolitician(walterbrown) & lawyer(walterbrown)) & servedas(walterbrown, postmastergeneral))).
fof(p2, axiom, (graduated(walterbrown, harvard) & graduatedwith(walterbrown, bachelorsofart))).
fof(p3, axiom, ? [T] : (((in(walterbrown, toledo, T) & in(walterbrownfather, toledo, T)) & practicedlawtogether(walterbrown, walterbrownfather, T)))).
fof(p4, axiom, married(katherinhafer, walterbrown)).
fof(extra1, axiom, ~(? [T] : (in(walterbrownfather, toledo, T)))).
