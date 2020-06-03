//
//  Storage.swift
//  
//
//  Created by Natchanon Luangsomboon on 27/5/2563 BE.
//

public typealias ScalarValue = Double

public protocol ScalarProtocol {
    var value: ScalarValue { get set }
}
extension Never: ScalarProtocol {
    public var value: ScalarValue { get { unreachable() } set { } }
}
extension ScalarValue: ScalarProtocol {
    @inlinable public var value: ScalarValue { get { self } set { self = newValue } }
}

public protocol Storage {
    associatedtype Included: Storage
    associatedtype Excluded: Storage
    associatedtype ScalarType: ScalarProtocol

    init()

    var included: Included { get set }
    var excluded: Excluded { get set }
    var scalar: ScalarType { get set }
}

#warning("Todo: Remove this")
public extension Mixed {
    @inlinable static func included(_ included: Included) -> Self { .init(included: included, excluded: .init()) }
    @inlinable static func excluded(_ excluded: Excluded) -> Self { .init(included: .init(), excluded: excluded) }
}

public struct Empty: Storage {
    @inlinable public init() { }

    @inlinable public var included: Empty { get { self } set { } }
    @inlinable public var excluded: Empty { get { self } set { } }
    public var scalar: Never { get { unreachable() } set { } }
}

public struct Scalar: Storage {
    @inlinable public init() { scalar = .init() }

    @inlinable public var included: Empty { get { .init() } set { } }
    @inlinable public var excluded: Self { get { self } set { self = newValue } }
    public var scalar: ScalarValue
}

public struct Mixed<Included: Storage, Excluded: Storage>: Storage {
    @inlinable public init() { excluded = .init() }
    @inlinable public init(included: Included, excluded: Excluded) {
        self.included = included
        self.excluded = excluded
    }

    public var included: Included = .init(), excluded: Excluded
    @inlinable public var scalar: Excluded.ScalarType { get { excluded.scalar } set { excluded.scalar = newValue } }
}
