//  Copyright © 2020 Eric M M PEI. All rights reserved.

import Foundation

public enum Alignment: Int {
    case one = 1, two = 2, four = 4, eight = 8
}

private let emptyPointer = UnsafeRawPointer(bitPattern: 0x01)!

/// A simple tool to spy on the memory.
public struct Memory<T> {
    
    // MARK: - Check the memory of value types.
    
    public static func pointer(ofValue value: inout T) -> UnsafeRawPointer {
        guard MemoryLayout<T>.size != 0 else {
            return emptyPointer
        }
        return withUnsafePointer(to: &value) { UnsafeRawPointer($0) }
    }
    
    public static func size(ofValue value: inout T) -> Int {
        guard MemoryLayout.size(ofValue: value) > 0 else {
            return 0
        }
        return MemoryLayout.stride(ofValue: value)
    }
    
    public static func memory(ofValue value: inout T,
                              onAlignment alignment: Alignment? = nil) -> String {
        let pointer = Self.pointer(ofValue: &value)
        let size = MemoryLayout.stride(ofValue: value)
        let alignmentValue: Int
        if let alignment = alignment {
            alignmentValue = alignment.rawValue
        } else {
            alignmentValue = MemoryLayout.alignment(ofValue: value)
        }
        
        return memory(ofPointer: pointer,
                      bySize: size,
                      onAlignment: Alignment(rawValue: alignmentValue) ?? .one)
    }
    
    // MARK: - Check the memory of reference types.
    
    public static func pointer(ofReference reference: T) -> UnsafeRawPointer {
        if reference is Array<Any>
            ||
            type(of: reference) is AnyClass
            ||
            reference is AnyClass {
            return UnsafeRawPointer(bitPattern: unsafeBitCast(reference, to: UInt.self))!
        } else if var string = reference as? String, string.memory.type() == .heap {
            return UnsafeRawPointer(bitPattern: unsafeBitCast(reference, to: (UInt, UInt).self).1)!
        } else {
            return emptyPointer
        }
    }
    
    public static func size(ofReference reference: T) -> Int {
        malloc_size(pointer(ofReference: reference))
    }
    
    public static func memory(ofReference reference: T,
                              onAlignment alignment: Alignment? = nil) -> String {
        let pointer = Self.pointer(ofReference: reference)
        let size = malloc_size(pointer)
        let alignmentValue: Int
        if let alignment = alignment {
            alignmentValue = alignment.rawValue
        } else {
            alignmentValue = MemoryLayout.alignment(ofValue: reference)
        }
        return memory(ofPointer: pointer,
                      bySize: size,
                      onAlignment: Alignment(rawValue: alignmentValue) ?? .one)
    }
}

// MARK: - Private helpers.

extension Memory {
    private static func memory(ofPointer pointer: UnsafeRawPointer,
                               bySize size: Int,
                               onAlignment alignment: Alignment) -> String {
        guard pointer != emptyPointer else {
            return ""
        }
        
        let result = stride(from: pointer, to: pointer + size, by: alignment.rawValue)
            .map {
                let value: CVarArg
                switch alignment {
                case .eight:
                    value = $0.load(as: UInt64.self)
                case .four:
                    value = $0.load(as: UInt32.self)
                case .two:
                    value = $0.load(as: UInt16.self)
                case .one:
                    value = $0.load(as: UInt8.self)
                }
                return makeHexadecimal(withCVarArg: value, onAlignment: alignment)
            }
            .joined(separator: " ")
        
        return result
    }
    
    private static func makeHexadecimal(withCVarArg arg: CVarArg,
                                        onAlignment alignment: Alignment) -> String {
        String(format: "0x%0\(alignment.rawValue << 1)lx", arg)
    }
}
