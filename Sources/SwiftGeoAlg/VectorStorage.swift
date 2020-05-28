//
//  VectorStorage.swift
//  
//
//  Created by Natchanon Luangsomboon on 27/5/2563 BE.
//

import Foundation

public protocol VectorStorage {
    associatedtype IncludedStorage: VectorStorage
    associatedtype ExcludedStorage: VectorStorage

    var included: IncludedStorage { get set }
    var excluded: ExcludedStorage { get set }

    init()
    mutating func add<Other: VectorStorage>(_ other: Other)
}

public protocol Vector: VectorStorage {
    associatedtype Current: Basis
}

public struct Empty: VectorStorage {
    public init() { }
    public mutating func add<Other>(_ other: Other) where Other : VectorStorage { }
    public var included: Empty { get { fatalError("Don't use this") } set { fatalError("Don't use this") } }
    public var excluded: Empty { get { fatalError("Don't use this") } set { fatalError("Don't use this") } }
}

public struct Scalar: VectorStorage {
    var value = 0.0
    public init() { }
    public mutating func add<Other>(_ other: Other) where Other : VectorStorage {
        if let other = other as? Self {
            value += other.value
        }
    }
    public var included: Empty { get { fatalError("Don't use this") } set { fatalError("Don't use this") } }
    public var excluded: Empty { get { fatalError("Don't use this") } set { fatalError("Don't use this") } }
}

public extension Vector {
    mutating func add<Other>(_ other: Other) where Other: VectorStorage {
        if Other.IncludedStorage.self != Empty.self {
            included.add(other.included)
        }
        if Other.ExcludedStorage.self != Empty.self {
            excluded.add(other.excluded)
        }
    }
}

// MARK: Multi-Dimension Vectors

public struct Vector0D<Current: Basis, PC: ProductChain>: Vector {
    public typealias IncludedStorage = Empty
    public typealias ExcludedStorage = PC.Storage
    public var included: IncludedStorage, excluded: ExcludedStorage
    public init() { included = .init(); excluded = .init() }
}

public struct Vector1D<Current: Basis, PC: ProductChain>: Vector {
    public typealias IncludedStorage = Vector0D<Current.Next, PC.Next>
    public typealias ExcludedStorage = Vector0D<Current.Next, PC>
    public var included: IncludedStorage, excluded: ExcludedStorage
    public init() { included = .init(); excluded = .init() }
}

/// First 2 Bases must be unique.
public struct Vector2D<Current: Basis, PC: ProductChain>: Vector {
    public typealias IncludedStorage = Vector1D<Current.Next, PC.Next>
    public typealias ExcludedStorage = Vector1D<Current.Next, PC>
    public var included: IncludedStorage, excluded: ExcludedStorage
    public init() { included = .init(); excluded = .init() }
}

/// First 3 Bases must be unique.
public struct Vector3D<Current: Basis, PC: ProductChain>: Vector {
    public typealias IncludedStorage = Vector2D<Current.Next, PC.Next>
    public typealias ExcludedStorage = Vector2D<Current.Next, PC>
    public var included: IncludedStorage, excluded: ExcludedStorage
    public init() { included = .init(); excluded = .init() }
}

/// First 4 Bases must be unique.
public struct Vector4D<Current: Basis, PC: ProductChain>: Vector {
    public typealias IncludedStorage = Vector3D<Current.Next, PC.Next>
    public typealias ExcludedStorage = Vector3D<Current.Next, PC>
    public var included: IncludedStorage, excluded: ExcludedStorage
    public init() { included = .init(); excluded = .init() }
}

/// First 5 Bases must be unique.
public struct Vector5D<Current: Basis, PC: ProductChain>: Vector {
    public typealias IncludedStorage = Vector4D<Current.Next, PC.Next>
    public typealias ExcludedStorage = Vector4D<Current.Next, PC>
    public var included: IncludedStorage, excluded: ExcludedStorage
    public init() { included = .init(); excluded = .init() }
}

/// First 6 Bases must be unique.
public struct Vector6D<Current: Basis, PC: ProductChain>: Vector {
    public typealias IncludedStorage = Vector5D<Current.Next, PC.Next>
    public typealias ExcludedStorage = Vector5D<Current.Next, PC>
    public var included: IncludedStorage, excluded: ExcludedStorage
    public init() { included = .init(); excluded = .init() }
}

/// First 7 Bases must be unique.
public struct Vector7D<Current: Basis, PC: ProductChain>: Vector {
    public typealias IncludedStorage = Vector6D<Current.Next, PC.Next>
    public typealias ExcludedStorage = Vector6D<Current.Next, PC>
    public var included: IncludedStorage, excluded: ExcludedStorage
    public init() { included = .init(); excluded = .init() }
}

/// First 8 Bases must be unique.
public struct Vector8D<Current: Basis, PC: ProductChain>: Vector {
    public typealias IncludedStorage = Vector7D<Current.Next, PC.Next>
    public typealias ExcludedStorage = Vector7D<Current.Next, PC>
    public var included: IncludedStorage, excluded: ExcludedStorage
    public init() { included = .init(); excluded = .init() }
}
