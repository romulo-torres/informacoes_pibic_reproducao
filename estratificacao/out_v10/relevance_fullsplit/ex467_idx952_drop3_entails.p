% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (((((((federaldistrictof(central, russia) & federaldistrictof(northwestern, russia)) & federaldistrictof(southern, russia)) & federaldistrictof(northcaucasian, russia)) & federaldistrictof(volga, russia)) & federaldistrictof(ural, russia)) & federaldistrictof(siberian, russia)) & federaldistrictof(fareastern, russia))).
fof(p2, axiom, largestpopulation(central)).
fof(p3, axiom, administrativecenterof(yekaterinburg, ural)).
fof(p4, axiom, administrativecenterof(vladivostok, fareastern)).
fof(p5, axiom, largestarea(fareastern)).
fof(p6, axiom, ? [X] : ((federaldistrictof(X, russia) & establishedin(X, num2000)))).
fof(extra1, axiom, ~(? [X] : ((administrativecenterof(vladivostok, X) & largestarea(X))))).
