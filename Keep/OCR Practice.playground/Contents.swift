//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


var fullName = "First Last"
var fullNameArr = split(fullName) {$0 == " "}
var firstName: String = fullNameArr[0]
var lastName: String? = fullNameArr.count > 1 ? fullNameArr[1] : nil

pring(firstName)