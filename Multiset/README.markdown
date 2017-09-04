# An implementation of the multiset data stucture

## Usage

``` swift
var b = Multiset<Character>();
for c in "hello".characters {
    b.add(c)
}
let count = b.count // count is 5
let lcount = b.count(for: "l") // lcount is 2
```
