import Foundation

// Position on a sphere in degrees latitude and longitude.
typealias Coordinate = (lat: Double, lon: Double)

func haversineDistance(a: Coordinate, b: Coordinate, radius: Double = 6367444.7) -> Double {
    
    let haversin = { (angle: Double) -> Double in
        return (1.0 - cos(angle)) / 2.0
    }
    
    let ahaversin = { (angle: Double) -> Double in
        return 2.0 * asin(sqrt(angle))
    }
    
    // Converts from degrees to radians
    let dToR = { (angle: Double) -> Double in
        return angle * Double.pi / 180.0
    }
    
    let lat1 = dToR(a.lat)
    let lon1 = dToR(a.lon)
    let lat2 = dToR(b.lat)
    let lon2 = dToR(b.lon)
    
    return radius * ahaversin(haversin(lat2 - lat1) + cos(lat1) * cos(lat2) * haversin(lon2 - lon1))
}

let amsterdam = (lat: 52.3702, lon: 4.8952)
let newYork = (lat: 40.7128, lon: -74.0059)

// The actual distance is ~5857 km. Our result is off by 2km because the Earth is not a perfect sphere.
haversineDistance(a: amsterdam, b: newYork)
