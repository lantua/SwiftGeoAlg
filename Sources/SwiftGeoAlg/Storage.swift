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

    mutating func reset()

    var included: Included { get set }
    var excluded: Excluded { get set }
    var scalar: ScalarValue { get set }
}

public extension Storage {
    mutating func reset() { self = .init() }
}

public extension Storage {
    static func included(_ included: Included) -> Self { .init(included: included, excluded: .init()) }
    static func excluded(_ excluded: Excluded) -> Self { .init(included: .init(), excluded: excluded) }
    init(floatLiteral value: Double.FloatLiteralType) { self.init(scalar: .init(floatLiteral: value)) }
}

public struct Empty: Storage {
    public init() { }
    public init(scalar: ScalarValue) { }
    public init(included: Empty, excluded: Empty) { }

    public var included: Empty { get { unreachable() } set { } }
    public var excluded: Empty { get { unreachable() } set { } }
    public var scalar: ScalarValue { get { .zero } set { } }
}

public struct Scalar: Storage {
    public init() { scalar = .zero }
    public init(scalar: ScalarValue) { self.scalar = scalar }
    public init(included: Empty, excluded: Scalar) { self = excluded }

    public var included: Empty { get { .init() } set { } }
    public var excluded: Self { get { self } set { self = newValue } }
    public var scalar: ScalarValue
}

public struct Mixed<Included: Storage, Excluded: Storage>: Storage {
    public init() { excluded = .init() }
    public init(scalar: ScalarValue) { excluded = .init(scalar: scalar) }
    public init(included: Included, excluded: Excluded) {
        self.included = included
        self.excluded = excluded
    }

    public var included: Included = .init(), excluded: Excluded
    public var scalar: ScalarValue { get { excluded.scalar } set { excluded.scalar = newValue } }
}
