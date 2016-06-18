/*
  Determines if there are any entries a[i] + a[j] == k in the array.
  Returns a tuple with the indices of the first pair of elements that sum to k.

  Uses a dictionary to store differences between the target and each element.
  If any value in the dictionary equals an element in the array, they sum to k.

  This is an O(n) solution.
*/
func twoSumProblem(a: [Int], k: Int) -> ((Int, Int))? {
  var map = [Int: Int]()

  for i in 0 ..< a.count {
    if let newK = map[a[i]] {
      return (newK, i)
    } else {
      map[k - a[i]] =  i
    }
  }

  return nil  // if empty array or no entries sum to target k
}
