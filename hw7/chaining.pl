%forward/backward chaining

notGoodToEat(X) :-soldAt(X, Y), skeevyPlace(Y), expirationDate(X, Z), Z > 60.

skeevyPlace(Y) :-sells(Y, gas).

soldAt(X, gasStation) :-color(yellow, X), \+ animal(X).

soldAt(X, farmersMarket) :- \+ color(yellow, X).

sells(gasStation, gas).

color(yellow, twinkies).

color(yellow, myCat).

color(green, soylentGreen). % Soylent Green is people!!!

expirationDate(twinkies, 999).

expirationDate(soylentGreen, 666).

animal(myCat).  