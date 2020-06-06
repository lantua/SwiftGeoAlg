//
//  Vector.swift
//  
//
//  Created by Natchanon Luangsomboon on 5/6/2563 BE.
//

public protocol VectorProtocol: Accumulable {
    associatedtype Included: VectorProtocol where Included.Bases == Bases.Tail
    associatedtype Excluded: VectorProtocol where Excluded.Bases == Bases.Tail
    associatedtype ScalarType: ScalarProtocol

    associatedtype NegateType: VectorProtocol = Negated<Self> where NegateType.Bases == Bases

    var included: Included { get }
    var excluded: Excluded { get }
    var scalar: ScalarType { get }

    var negated: NegateType { get }
}
extension VectorProtocol where NegateType == Negated<Self> {
    @inlinable public var negated: NegateType { .init(base: self) }
}

public struct Vector<Bases: BasisChain, S: Storage>: VectorProtocol {
    @usableFromInline var storage: S
    @inlinable public init(storage: S = .init()) { self.storage = storage }

    @inlinable public var included: Vector<Bases.Tail, S.Included> { .init(storage: storage.included) }
    @inlinable public var excluded: Vector<Bases.Tail, S.Excluded> { .init(storage: storage.excluded) }
    @inlinable public var scalar: S.ScalarType { storage.scalar }
}

public struct Negated<V: VectorProtocol>: VectorProtocol {
    public typealias Bases = V.Bases
    @usableFromInline var base: V
    @inlinable init(base: V) { self.base = base }

    @inlinable public var included: Negated<V.Included> { .init(base: base.included) }
    @inlinable public var excluded: Negated<V.Excluded> { .init(base: base.excluded) }
    @inlinable public var scalar: V.ScalarType.Negate { base.scalar.negate }

    @inlinable public var negated: V { base }
}
public struct Reverse<V: VectorProtocol>: VectorProtocol {
    public typealias Bases = V.Bases
    @usableFromInline var base: V
    @inlinable init(base: V) { self.base = base }

    @inlinable public var included: Reverse<V.Included.NegateType> { .init(base: base.included.negated) }
    @inlinable public var excluded: Reverse<V.Excluded> { .init(base: base.excluded) }
    @inlinable public var scalar: V.ScalarType { base.scalar }
}

extension VectorProtocol {
    @inlinable public static func +=<O>(lhs: inout Vector<Bases, O>, rhs: Self) { rhs.add(to: &lhs.storage) }
    @inlinable public static func -=<O>(lhs: inout Vector<Bases, O>, rhs: Self) { rhs.negated.add(to: &lhs.storage) }

    @inlinable func add<O: Storage>(to out: inout O) {
        guard Bases.self != EndBasisChain.self else {
            guard O.ScalarType.self != Never.self, ScalarType.self != Never.self else {
                return
            }

            out.scalar.value += scalar.value
            return
        }

        included.add(to: &out.included)
        excluded.add(to: &out.excluded)
    }
}
