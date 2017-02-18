
//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let techJobs = ["a","b","c","d","e"]
let responsesArray = [1,4,4,2,0]
let array2 = [1,4,3,2,4]

var emptryJobArray:[String] = []

let max = responsesArray.max()
if let maxN = max {
   print(maxN)
}

var counter = 0
var emptyArray:[Int] = []

for (i,n) in responsesArray.enumerated() {
    if n == max {
        counter += 1
        emptyArray.append(i)
        // recording index value to find out the category
    }
}

// final result
print(emptyArray)

for n in emptyArray {
    emptryJobArray.append(techJobs[n])
}

print(emptryJobArray) // what jobs for the same number of yes responses?

if counter > 1 {
  
}








