//
//  Storage.swift
//  
//
//  Created by Natchanon Luangsomboon on 27/5/2563 BE.
//

public typealias ScalarValue = Double

public protocol ScalarProtocol {
    associatedtype Negate: ScalarProtocol
    var value: ScalarValue { get set }
    var negate: Negate  { get }
}
extension Never: ScalarProtocol {
    public var value: ScalarValue { get { unreachable() } set { } }
    public var negate: Self { unreachable() }
}
extension ScalarValue: ScalarProtocol {
    @inlinable public var value: ScalarValue { get { self } set { self = newValue } }
    @inlinable public var negate: ScalarValue { get { -self } }
}

public protocol Storage {
    associatedtype Included: Storage = Empty
    associatedtype Excluded: Storage = Empty
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
public extension Mixed {
    @inlinable static func included(_ included: Included) -> Self { .init(included: included, excluded: .init()) }
    @inlinable static func excluded(_ excluded: Excluded) -> Self { .init(included: .init(), excluded: excluded) }
}

public struct Empty: Storage {
    @inlinable public init() { }
}
public struct Scalar: Storage {
    @inlinable public init() { scalar = .init() }

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
}
