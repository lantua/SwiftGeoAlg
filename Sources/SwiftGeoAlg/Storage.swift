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
    associatedtype Included: Storage = Empty
    associatedtype Excluded: Storage = Empty
    associatedtype Swap: Storage
    associatedtype ScalarType: ScalarProtocol = Never

    init()

    var included: Included { get set }
    var excluded: Excluded { get set }
    var scalar: ScalarType { get set }
}
extension Storage where ScalarType == Never {
    public var scalar: ScalarType { get { unreachable() } set { } }
}
extension Storage where Included == Empty {
    @inlinable public var included: Included { get { .init() } set { } }
}
extension Storage where Excluded == Empty {
    @inlinable public var excluded: Excluded { get { .init() } set { } }
}

#warning("Todo: Remove this")
public extension MixedIE {
    @inlinable static func included(_ included: Included) -> Self { .init(included: included, excluded: .init()) }
    @inlinable static func excluded(_ excluded: Excluded) -> Self { .init(included: .init(), excluded: excluded) }
}
public extension MixedEI {
    @inlinable static func included(_ included: Included) -> Self { .init(included: included, excluded: .init()) }
    @inlinable static func excluded(_ excluded: Excluded) -> Self { .init(included: .init(), excluded: excluded) }
}

public struct Empty: Storage {
    public typealias Swap = Self

    @inlinable public init() { }
}
public struct Scalar: Storage {
    public typealias Swap = PseudoScalar

    @inlinable public init() { scalar = .init() }

    @inlinable public var excluded: Self { get { self } set { self = newValue } }
    public var scalar: ScalarValue
}
public struct PseudoScalar: Storage {
    public typealias Swap = Scalar

    @inlinable public init() { scalar = .init() }

    @inlinable public var included: Self { get { self } set { self = newValue } }
    public var scalar: ScalarValue
}

public struct MixedIE<Included: Storage, Excluded: Storage>: Storage {
    public typealias Swap = MixedEI<Included.Swap, Excluded.Swap>

    @inlinable public init() { excluded = .init() }
    @inlinable public init(included: Included, excluded: Excluded) {
        self.included = included
        self.excluded = excluded
    }

    public var included: Included = .init(), excluded: Excluded
}
public struct MixedEI<Excluded: Storage, Included: Storage>: Storage {
    public typealias Swap = MixedIE<Included.Swap, Excluded.Swap>

    @inlinable public init() { excluded = .init() }
    @inlinable public init(included: Included, excluded: Excluded) {
        self.included = included
        self.excluded = excluded
    }

    public var excluded: Excluded, included: Included = .init()
}
