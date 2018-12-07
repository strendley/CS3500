%zoology

animal(X) :- mammal(X).
animal(X) :- bird(X).
animal(X) :- fish(X).

covering(X, fur) :- mammal(X).
covering(X, feathers) :- bird(X).
covering(X, scales) :- fish(X).

legs(X, 2) :- primate(X).
legs(X, 4) :- mammal(X).
legs(X, 2) :- bird(X).
legs(X, 0) :- fish(X).

mammal(X) :- cat(X).
mammal(X) :- dog(X).
mammal(X) :- primate(X).

sound(X, purr) :- cat(X).
sound(X, bark) :- dog(X).

cat(sylvester).
cat(felix).

dog(spike).
dog(fido).

primate(george).
primate(kingKong).

bird(tweety).
bird(X) :- hawk(X).

hawk(tony).

fish(nemo).