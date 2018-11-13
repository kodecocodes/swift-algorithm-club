import UIKit

func haversineDinstance(la1: Double, lo1: Double, la2: Double, lo2: Double, radius: Double = 6367444.7) -> Double {
    
    let haversin = { (angle: Double) -> Double in
        return (1 - cos(angle))/2
    }
    
    let ahaversin = { (angle: Double) -> Double in
        return 2*asin(sqrt(angle))
    }
    
    // Converts from degrees to radians
    let dToR = { (angle: Double) -> Double in
        return (angle / 360) * 2 * .pi
    }
    
    let lat1 = dToR(la1)
    let lon1 = dToR(lo1)
    let lat2 = dToR(la2)
    let lon2 = dToR(lo2)
    
    return radius * ahaversin(haversin(lat2 - lat1) + cos(lat1) * cos(lat2) * haversin(lon2 - lon1))
}

let amsterdam = (52.3702, 4.8952)
let newYork = (40.7128, -74.0059)

// Google says it's 5857 km so our result is only off by 2km which could be due to all kinds of things, not sure how google calculates the distance or which latitude and longitude google uses to calculate the distance.
haversineDinstance(la1: amsterdam.0, lo1: amsterdam.1, la2: newYork.0, lo2: newYork.1)
