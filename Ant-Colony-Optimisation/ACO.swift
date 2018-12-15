func ACO(distanceMatrix: [[Int]], alpha: Double, beta: Double, p: Double, Q: Int, e: Int, numberOfCities: Int, colonyLifeTime: Int, theShortestWay: inout [Int], routeLength: inout Int){

    var costToCity = 0
    var currentCity = 0

    var currentIteration : Int = 0

    var visibility = instantiateMatrix(withDigits: 0.0, m: numberOfCities, n: numberOfCities)
    var pheromonus = instantiateMatrix(withDigits: 0.5, m: numberOfCities , n: numberOfCities)

    // initiate pheromonus & visibility data
    for i in 0..<numberOfCities{
        for j in 0..<numberOfCities{
            if distanceMatrix[i][j] != 0{
                visibility[i][j] = Double(1 / (Double(distanceMatrix[i][j])))
            } else {
                visibility[i][j] = Double.infinity
            }
        }
    }

    // general colonyLifeTime while loop
    while currentIteration < colonyLifeTime{

        // instantiating pheromonus matrix for updating it after the main part
        var allAntsPheromonus = instantiateMatrix(withDigits: 0.0, m: numberOfCities, n: numberOfCities)

        // ants loop
        for k in 0..<numberOfCities{

            costToCity = 0
            currentCity = k
            var citiesAntVisited = [k]

            while citiesAntVisited.count != numberOfCities{

                var toBeVisited = [Int]()

                for t in 0..<numberOfCities {
                    toBeVisited.append(t)
                }

                // keeping ant's entities up to date
                for visitedCity in citiesAntVisited{
                    toBeVisited.removeAll(where: { $0 == visitedCity }) // removes city if it was visited from the planned cities list
                }

                var possibility = [Double](repeating: 0.0, count: numberOfCities)

                for j in toBeVisited{

                    if (distanceMatrix[currentCity][j] != 0){
                        var denom: Double = 0.0

                        // summing up denominator
                        for q in toBeVisited{
                            denom += pow(pheromonus[currentCity][q], alpha) * pow(visibility[currentCity][q], beta)
                        }


                        guard let posInd = toBeVisited.index(of : j) else {return}

                        possibility[posInd] = (pow(pheromonus[currentCity][j], alpha) * pow(visibility[currentCity][j], beta)) / denom

                    } else{
                        guard let posInd2 = toBeVisited.index(of : j) else {return}
                        possibility[posInd2] = 0.0

                    }
                }

                let x = Double.random(in: ClosedRange(uncheckedBounds: (0.0, 1.0)))
                var sum : Double = 0.0

                // get index of the city where ant will move
                var cityChosen = 0

                for o in toBeVisited{
                    sum += possibility[o]
                    if x <= sum && toBeVisited.contains(o){
                        cityChosen = o
                        break
                    }
                }

                citiesAntVisited.append(toBeVisited[cityChosen])
                costToCity += distanceMatrix[currentCity][toBeVisited[cityChosen]]
                currentCity = toBeVisited[cityChosen]
                toBeVisited.removeAll(where: { $0 == cityChosen })
            }

            if ( routeLength == 0 || ( (costToCity + distanceMatrix[citiesAntVisited.first!][citiesAntVisited.last!]) < routeLength )){
                routeLength = costToCity + distanceMatrix[citiesAntVisited.first!][citiesAntVisited[citiesAntVisited.last!]]

                theShortestWay.removeAll()
                for each in citiesAntVisited{
                    theShortestWay.append(each)
                }
            }

            // strengthen pheromonus
            for i in 0..<citiesAntVisited.count-1{

                allAntsPheromonus[citiesAntVisited[i]][citiesAntVisited[i+1]] += Double(Q) / Double(routeLength)
            }
        }

        // check for influence of the elite Ants
        var eliteAntsPheromonusAffect : Double = 0.0


        if routeLength != 0{
            eliteAntsPheromonusAffect = Double(e * Q) / Double(routeLength)
        } else { eliteAntsPheromonusAffect = 0.0 }


        // ambient's affection for pheromonus exhalation
        for i in 0..<numberOfCities{
            for j in 0..<numberOfCities{
                    pheromonus[i][j] = (1-p) * pheromonus[i][j] + allAntsPheromonus[i][j] + eliteAntsPheromonusAffect

                    if pheromonus[i][j] == 0.0{
                        pheromonus[i][j] = 0.0001
                    }
            }
        }

        currentIteration += 1

    }

    routeLength = 0
    for i in 0..<numberOfCities-1{
        routeLength += distanceMatrix[theShortestWay[i]][theShortestWay[i+1]]
    }
}
