import Foundation

// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

/*:
 ## Naive Bayes Classifier

 This playground uses the given algorithm and utilizes its features with some example datasets

 ### Gaussian Naive Bayes
 - Note:
 When using Gaussian NB you have to have continuous features (Double).

 For this example we are going to use a famous dataset with different types of wine. The labels of the features can be viewed [here](https://gist.github.com/tijptjik/9408623)
 */
guard let wineCSV = Bundle.main.path(forResource: "wine", ofType: "csv") else {
    print("Resource could not be found!")
    exit(0)
}

guard let csv = try? String(contentsOfFile: wineCSV) else {
    print("File could not be read!")
    exit(0)
}

/*:
 Reading the .csv file line per line
 */
let rows = csv.characters.split(separator: "\r\n").map { String($0) }
/*:
 Splitting on the ; sign and converting the value to a Double

 - Important:
 Do not force unwrap the mapped values in your real application. Carefully convert them! This is just for the sake of showing how the algorithm works.
 */
let wineData = rows.map { row -> [Double] in
    let split = row.characters.split(separator: ";")
    return split.map { Double(String($0))! }
}

/*:
 The algorithm wants the classes and the data seperated since this gives a huge performance boost. Also I haven't implemented this in the NB class itself since it is not in the scope of it.
 */
let rowOfClasses = 0
let classes = wineData.map { Int($0[rowOfClasses]) }
let data = wineData.map { row in
    return row.enumerated().filter { $0.offset != rowOfClasses }.map { $0.element }
}

/*:
 Again use `guard` on the result of a `try?` or simply `do-try-catch` because this would crash your application if an error occured.

 The array in the `classifyProba` method I passed is a former entry in the .csv file which I removed in order to classify it.
 */
let wineBayes = try! NaiveBayes(type: .gaussian, data: data, classes: classes).train()
let result = wineBayes.classifyProba(with: [12.85, 1.6, 2.52, 17.8, 95, 2.48, 2.37, 0.26, 1.46, 3.93, 1.09, 3.63, 1015])
/*:
 I can assure you that ***class 1*** is the correct result and as you can see the classifier thinks that its ***99.99%*** likely too.

 ### Multinomial Naive Bayes

 - Note:
 When using Multinomial NB you have to have categorical features (Int).

 Now this dataset is commonly used to describe the classification problem and it is categorical which means you don't have real values you just have categorical data as stated before. The structure of this dataset is as follows.

 Outlook,Temperature,Humidity,Windy

 ***Outlook***: 0 = rainy, 1 = overcast, 2 = sunny

 ***Temperature***: 0 = hot, 1 = mild, 2 = cool

 ***Humidity***: 0 = high, 1 = normal

 ***Windy***: 0 = false, 1 = true

 The classes are either he will play golf or not depending on the weather conditions. (0 = won't play, 1 = will play)
 */

let golfData = [
    [0, 0, 0, 0],
    [0, 0, 0, 1],
    [1, 0, 0, 0],
    [2, 1, 0, 0],
    [2, 2, 1, 0],
    [2, 2, 1, 1],
    [1, 2, 1, 1],
    [0, 1, 0, 0],
    [0, 2, 1, 0],
    [2, 1, 1, 0],
    [0, 1, 1, 1],
    [1, 1, 0, 1],
    [1, 0, 1, 0],
    [2, 1, 0, 1]
]
let golfClasses =  [0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0]

let golfNaive = try! NaiveBayes(type: .multinomial, data: golfData, classes: golfClasses).train()

/*:
 The weather conditions is as follows now: Outlook=rainy, Temperature=cool, Humidity=high, Windy=true
 */
let golfResult = golfNaive.classifyProba(with: [0, 2, 0, 1])

/*:
 Naive Bayes tells us that the golf player will ***not*** play with a likelihood of almost ***80%***. Which is true of course.
 */
