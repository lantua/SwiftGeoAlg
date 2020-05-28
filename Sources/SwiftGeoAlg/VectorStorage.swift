//
//  VectorStorage.swift
//  
//
//  Created by Natchanon Luangsomboon on 27/5/2563 BE.
//

import Foundation

public protocol VectorStorage {
    associatedtype Included: VectorStorage = Empty
    associatedtype Excluded: VectorStorage = Empty
    var included: Included { get set }
    var excluded: Excluded { get set }

    init()
    mutating func add<Other: VectorStorage>(other: Other)
}

public extension VectorStorage where Included == Empty, Excluded == Empty {
    var included: Included { get { unreachable() } set { unreachable() } }
    var excluded: Excluded { get { unreachable() } set { unreachable() } }
}

public struct Scalar: VectorStorage {
    var value: Double

    public init() { value = 0 }
    public mutating func add<Other>(other: Other) where Other : VectorStorage {
        if let other = other as? Self {
            value += other.value
        }
    }
}
public struct Empty: VectorStorage {
    public init() { }
    public func add<Other>(other: Other) where Other : VectorStorage { /* Do nothing */ }
}

public struct Vector<Current: Basis, Included: VectorStorage, Excluded: VectorStorage>: VectorStorage {
    public var included: Included, excluded: Excluded

    public init() {
        included = .init()
        excluded = .init()
    }

    public mutating func add<Other>(other: Other) where Other : VectorStorage {
        if Other.Included.self != Empty.self {
            included.add(other: other.included)
        }
        if Other.Excluded.self != Empty.self {
            excluded.add(other: other.excluded)
        }
    }
}
