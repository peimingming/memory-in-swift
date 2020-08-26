# memory-in-swift
A simple tool to spy on memory in Swift.



> SPECIAL ANNOUNCEMENT
>
> Totally inspired by [Mems](https://github.com/CoderMJLee/Mems), for the sake of learning Swift only.



## Consume The Tool?

Simply drag the Swift file `Memory.swift` & `MemoryWrapper.swift` into your project, and refer to the `main.swift` to know what it can do, or see below directly:



### Usage

```swift
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
```



### Int

```swift
var int8: Int8 = 10
show(value: &int8)
// -------------- function: showInt(), Int8 --------------
// pointer: 0x00007ffeefbff498
// memory: 0x0a
// size: 1

var int16: Int16 = 10
show(value: &int16)
// -------------- function: showInt(), Int16 --------------
// pointer: 0x00007ffeefbff490
// memory: 0x000a
// size: 2

var int32: Int32 = 10
show(value: &int32)
// -------------- function: showInt(), Int32 --------------
// pointer: 0x00007ffeefbff488
// memory: 0x0000000a
// size: 4

var int64: Int64 = 10
show(value: &int64)
// -------------- function: showInt(), Int64 --------------
// pointer: 0x00007ffeefbff480
// memory: 0x000000000000000a
// size: 8

var int: Int = 10
show(value: &int)
// -------------- function: showInt(), Int --------------
// pointer: 0x00007ffeefbff478
// memory: 0x000000000000000a
// size: 8
```



### enum

```swift
enum Season {
    case spring(Int, Int, Int)
    case summer(Int, Int)
    case autumn(Int)
    case winter(Bool)
    case test
}

var season = Season.spring(1, 2, 3)
show(value: &season)
// -------------- function: showEnum(), Season --------------
// pointer: 0x00007ffeefbff480
// memory: 0x0000000000000001 0x0000000000000002 0x0000000000000003 0x0000000000000000
// size: 32

season = .summer(10, 20)
show(value: &season)
// -------------- function: showEnum(), Season --------------
// pointer: 0x00007ffeefbff480
// memory: 0x000000000000000a 0x0000000000000014 0x0000000000000000 0x0000000000000001
// size: 32

season = .autumn(30)
show(value: &season)
// -------------- function: showEnum(), Season --------------
// pointer: 0x00007ffeefbff480
// memory: 0x000000000000001e 0x0000000000000000 0x0000000000000000 0x0000000000000002
// size: 32

season = .winter(true)
show(value: &season)
// -------------- function: showEnum(), Season --------------
// pointer: 0x00007ffeefbff480
// memory: 0x0000000000000001 0x0000000000000000 0x0000000000000000 0x0000000000000003
// size: 32

season = .test
show(value: &season)
// -------------- function: showEnum(), Season --------------
// pointer: 0x00007ffeefbff480
// memory: 0x0000000000000000 0x0000000000000000 0x0000000000000000 0x0000000000000004
// size: 32
```



### struct

```swift
struct Person {
    let id: Int
    let age: Int
    let isStudent: Bool
}

var person = Person(id: 10, age: 20, isStudent: true)
show(value: &person)
// -------------- function: showStruct(), Person --------------
// pointer: 0x00007ffeefbff480
// memory: 0x000000000000000a 0x0000000000000014 0x0000000000000001
// size: 24
```



### class

```swift
class Student {
    let name: String = "unassigned"
    let age: Int = 20
    let score: Int = 100
}

var student = Student()
show(value: &student)
// -------------- function: showClass(), Student --------------
// pointer: 0x00007ffeefbff490
// memory: 0x000000010312aab0
// size: 8

show(reference: student)
// -------------- function: showClass(), Student --------------
// pointer: 0x000000010312aab0
// memory: 0x00000001000098a8 0x0000000200000002 0x6e67697373616e75 0xea00000000006465 0x0000000000000014 0x0000000000000064
// size: 48
```



### Array

```swift
var array = [1, 2, 3, 4]
show(value: &array)
// -------------- function: showArray(), Array<Int> --------------
// pointer: 0x00007ffeefbff498
// memory: 0x0000000100500d60
// size: 8

show(reference: array)
// -------------- function: showArray(), Array<Int> --------------
// pointer: 0x0000000100500d60
// memory: 0x00007fff9ccd8470 0x0000000200000002 0x0000000000000004 0x0000000000000008 0x0000000000000001 0x0000000000000002 0x0000000000000003 0x0000000000000004
// size: 64
```



### String

```swift
var string1 = "123456789"
print(string1.memory.type())
show(value: &string1)
// taggerPointer
// -------------- function: showString(), String --------------
// pointer: 0x00007ffeefbff480
// memory: 0x3837363534333231 0xe900000000000039
// size: 16

var string2 = "1234567812345678"
print(string2.memory.type())
show(value: &string2)
// text
// -------------- function: showString(), String --------------
// pointer: 0x00007ffeefbff440
// memory: 0xd000000000000010 0x8000000100008b30
// size: 16

var string3 = "1234567812345678"
string3.append("9")
print(string3.memory.type())
// heap
show(value: &string3)
// -------------- function: showString(), String --------------
// pointer: 0x00007ffeefbff400
// memory: 0xf000000000000011 0x0000000100500d60
// size: 16
show(reference: string3)
// -------------- function: showString(), String --------------
// pointer: 0x0000000100500d60
// memory: 0x00007fff9ccae8b0 0x0000000200000002 0x0000000000000018 0xf000000000000011 0x3837363534333231 0x3837363534333231 0x0000000000000039 0x0000000000000000
// size: 64
```



### Show Bytes

```swift
var int = 10
print("print in 1 byte  :", Memory.memory(ofValue: &int, onAlignment: .one))
// print in 1 byte  : 0x0a 0x00 0x00 0x00 0x00 0x00 0x00 0x00

print("print in 2 bytes :", Memory.memory(ofValue: &int, onAlignment: .two))
// print in 2 bytes : 0x000a 0x0000 0x0000 0x0000

print("print in 4 bytes :", Memory.memory(ofValue: &int, onAlignment: .four))
// print in 4 bytes : 0x0000000a 0x00000000

print("print in 8 bytes :", Memory.memory(ofValue: &int, onAlignment: .eight))
// print in 8 bytes : 0x000000000000000a
```
