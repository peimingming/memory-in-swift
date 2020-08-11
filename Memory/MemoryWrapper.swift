//  Copyright © 2020 Eric M M PEI. All rights reserved.

import Foundation

public enum StringMemoryType: UInt8 {
    case text = 0xd0
    case taggerPointer = 0xe0
    case heap = 0xf0
    case unknown = 0xff
}

public struct MemoryWrapper<Base> {
    public private(set) var base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol MemoryCompatible {}

extension MemoryCompatible {
    static var memory: MemoryWrapper<Self>.Type {
        get { MemoryWrapper<Self>.self }
        set {}
    }
    var memory: MemoryWrapper<Self> {
        get { MemoryWrapper(self) }
        set {}
    }
}

extension String: MemoryCompatible {}

extension MemoryWrapper where Base == String {
    mutating func type() -> StringMemoryType {
        let pointer = Memory.pointer(ofValue: &base)
        
        func makePossibleType(withOffset offset: Int) -> StringMemoryType? {
            StringMemoryType(rawValue: (pointer + offset).load(as: UInt8.self) & 0xf0)
        }
        
        return makePossibleType(withOffset: 15) ?? makePossibleType(withOffset: 7) ?? .unknown
    }
}
