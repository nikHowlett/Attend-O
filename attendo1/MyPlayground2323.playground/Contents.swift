//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
var bitch = "CS/PSYC-3790-A"
var angel = bitch.componentsSeparatedByString("/")
print(angel[1])










var bitcho = bitch.rangeOfString("/")
print(bitcho)
let tony = bitch.removeRange(bitcho!)
print(tony)
//print(count(bitch))
print(bitch)
var april = 0
for (var FUCK = 0; FUCK < bitch.characters.count;FUCK++) {
    var jeggie = str.startIndex.advancedBy(FUCK)
    print(jeggie)
    print(bitch[jeggie])
    if bitch[jeggie] == "/" {
        april = FUCK
    }
}
print(april)
