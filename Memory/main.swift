//  Copyright © 2020 Eric M M PEI. All rights reserved.

import Foundation

func show<T>(value: inout T, function: String = #function) {
    print("-------------- function: \(function), \(type(of: value)) --------------")
    print("pointer:", Memory.pointer(ofValue: &value))
    print("memory:", Memory.memory(ofValue: &value))
    print("size:", Memory.size(ofValue: &value))
    print("")
}

func show<T>(reference: T, function: String = #function) {
    print("-------------- function: \(function), \(type(of: reference)) --------------")
    print("pointer:", Memory.pointer(ofReference: reference))
    print("memory:", Memory.memory(ofReference: reference))
    print("size:", Memory.size(ofReference: reference))
    print("")
}

func showInt() {
    var int8: Int8 = 10
    show(value: &int8)
    
    var int16: Int16 = 10
    show(value: &int16)
    
    var int32: Int32 = 10
    show(value: &int32)
    
    var int64: Int64 = 10
    show(value: &int64)
    
    var int: Int = 10
    show(value: &int)
}

showInt()

func showEnum() {
    enum Season {
        case spring(Int, Int, Int)
        case summer(Int, Int)
        case autumn(Int)
        case winter(Bool)
        case test
    }

    var season = Season.spring(1, 2, 3)
    show(value: &season)
    season = .summer(10, 20)
    show(value: &season)
    season = .autumn(30)
    show(value: &season)
    season = .winter(true)
    show(value: &season)
    season = .test
    show(value: &season)
}

showEnum()

func showStruct() {
    struct Person {
        let id: Int
        let age: Int
        let isStudent: Bool
    }
    
    var person = Person(id: 10, age: 20, isStudent: true)
    show(value: &person)
}

showStruct()

func showClass() {
    class Student {
        let name: String = "unassigned"
        let age: Int = 20
        let score: Int = 100
    }
    
    var student = Student()
    show(value: &student)
    show(reference: student)
}

showClass()

func showArray() {
    var array = [1, 2, 3, 4]
    show(value: &array)
    show(reference: array)
}

showArray()

func showString() {
    var string1 = "123456789"
    print(string1.memory.type())
    show(value: &string1)
    
    var string2 = "1234567812345678"
    print(string2.memory.type())
    show(value: &string2)
    
    var string3 = "1234567812345678"
    string3.append("9")
    print(string3.memory.type())
    show(value: &string3)
    show(reference: string3)
}

showString()

func showBytes() {
    var int = 10
    print("print in 1 byte  :", Memory.memory(ofValue: &int, onAlignment: .one))
    print("print in 2 bytes :", Memory.memory(ofValue: &int, onAlignment: .two))
    print("print in 4 bytes :", Memory.memory(ofValue: &int, onAlignment: .four))
    print("print in 8 bytes :", Memory.memory(ofValue: &int, onAlignment: .eight))
}

showBytes()
