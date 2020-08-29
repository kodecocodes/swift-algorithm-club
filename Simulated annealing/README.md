# Simulated annealing

Simulated Annealing is a nature inspired global optimization technique and a metaheuristic to approximate global maxima in a (often discrete)large search space. The name comes from the process of annealing in metallurgy where a material is heated and cooled down under controlled conditions in order to improve its strength and durabilility. The objective is to find a minimum cost solution in the search space by exploiting properties of a thermodynamic system. 
Unlike hill climbing techniques which usually gets stuck in a local maxima ( downward moves are not allowed ), simulated annealing can escape local maxima. The interesting property of simulated annealing is that probability of allowing downward moves is high at the high temperatures and gradually reduced as it cools down. In other words, high temperature relaxes the acceptance criteria for the search space and triggers chaotic behavior of acceptance function in the algorithm (e.x initial/high temperature stages) which should make it possible to escape from local maxima and cooler temperatures narrows it and focuses on improvements.

Pseucocode

	Input: initial, temperature, coolingRate, acceptance
	Output: Sbest
	Scurrent <- CreateInitialSolution(initial)
	Sbest <- Scurrent
	while temperature is not minimum:
		Snew <- FindNewSolution(Scurrent)
		if acceptance(Energy(Scurrent), Energy(Snew), temperature) > Rand():
			Scurrent = Snew
		if Energy(Scurrent) < Energy(Sbest):
			Sbest = Scurrent
		temperature = temperature * (1-coolingRate)
	
Common acceptance criteria : 

	P(accept) <- exp((e-ne)/T) where 
		e is the current energy ( current solution ), 
		ne is new energy ( new solution ),
		T is current temperature.


We use this algorithm to solve a Travelling salesman problem instance with 20 cities. The code is in `simann_example.swift`

#See also

[Simulated annealing on Wikipedia](https://en.wikipedia.org/wiki/Simulated_annealing) 

[Travelling salesman problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem)

Written for Swift Algorithm Club by [Mike Taghavi](https://github.com/mitghi)
