//
//  VectorStorage.swift
//  
//
//  Created by Natchanon Luangsomboon on 27/5/2563 BE.
//

import Foundation

public protocol VectorStorage {
    typealias ScalarValue = Double
    associatedtype Included: VectorStorage = Never
    associatedtype Excluded: VectorStorage = Never

    init()

    static var isEmpty: Bool { get }
    var scalar: ScalarValue { get }
    var included: Included { get }
    var excluded: Excluded { get }
}

public extension VectorStorage where Included == Never, Excluded == Never {
    var included: Included { unreachable() }
    var excluded: Excluded { unreachable() }
}

extension Never: VectorStorage {
    public init() { unreachable() }
    public static var isEmpty: Bool { unreachable() }
    public var scalar: ScalarValue { unreachable() }
}

public struct Empty: VectorStorage {
    public init() { }
    public static var isEmpty: Bool { true }
    public var scalar: ScalarValue { unreachable() }
}

public struct Scalar: VectorStorage {
    public var value: Double
    public init(value: Double) { self.value = value }

    public init() { value = .zero }
    public static var isEmpty: Bool { false }
    public var scalar: ScalarValue { value }
}

public struct Vector<Included: VectorStorage, Excluded: VectorStorage>: VectorStorage {
    public var included: Included, excluded: Excluded

    public init() {
        included = .init()
        excluded = .init()
    }
    public static var isEmpty: Bool { Included.isEmpty && Excluded.isEmpty }
    public var scalar: ScalarValue { unreachable() }
}
