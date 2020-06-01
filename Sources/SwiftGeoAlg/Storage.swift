//
//  Storage.swift
//  
//
//  Created by Natchanon Luangsomboon on 27/5/2563 BE.
//

public typealias ScalarValue = Double

public protocol Storage: ExpressibleByFloatLiteral {
    associatedtype Included: Storage
    associatedtype Excluded: Storage

    init()
    init(scalar: ScalarValue)
    init(included: Included, excluded: Excluded)

    var included: Included { get set }
    var excluded: Excluded { get set }
    var scalar: ScalarValue { get set }
}

#warning("Todo: Remove this")
public extension Storage {
    @inlinable static func included(_ included: Included) -> Self { .init(included: included, excluded: .init()) }
    @inlinable static func excluded(_ excluded: Excluded) -> Self { .init(included: .init(), excluded: excluded) }
    @inlinable init(floatLiteral value: Double.FloatLiteralType) { self.init(scalar: .init(floatLiteral: value)) }
}

public struct Empty: Storage {
    @inlinable public init() { }
    @inlinable public init(scalar: ScalarValue) { }
    @inlinable public init(included: Empty, excluded: Empty) { }

    public var included: Empty { get { unreachable() } set { } }
    public var excluded: Empty { get { unreachable() } set { } }
    @inlinable public var scalar: ScalarValue { get { .zero } set { } }
}

public struct Scalar: Storage {
    @inlinable public init() { scalar = .zero }
    @inlinable public init(scalar: ScalarValue) { self.scalar = scalar }
    @inlinable public init(included: Empty, excluded: Scalar) { self = excluded }

    @inlinable public var included: Empty { get { .init() } set { } }
    @inlinable public var excluded: Self { get { self } set { self = newValue } }
    public var scalar: ScalarValue
}

public struct Mixed<Included: Storage, Excluded: Storage>: Storage {
    @inlinable public init() { excluded = .init() }
    @inlinable public init(scalar: ScalarValue) { excluded = .init(scalar: scalar) }
    @inlinable public init(included: Included, excluded: Excluded) {
        self.included = included
        self.excluded = excluded
    }

    public var included: Included = .init(), excluded: Excluded
    @inlinable public var scalar: ScalarValue { get { excluded.scalar } set { excluded.scalar = newValue } }
}
