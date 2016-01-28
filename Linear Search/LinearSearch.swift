func linearSearch<T: Comparable>(array: [T], object:T) -> Int? {
    for (index, obj) in array.enumerate() where obj == object {
        return index
    }
    return nil
}