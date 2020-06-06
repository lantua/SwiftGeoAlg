//
//  Vector.swift
//  
//
//  Created by Natchanon Luangsomboon on 5/6/2563 BE.
//

public protocol VectorProtocol {
    associatedtype Bases: BasisChain
    associatedtype Included: VectorProtocol where Included.Bases == Bases.Tail
    associatedtype Excluded: VectorProtocol where Excluded.Bases == Bases.Tail
    associatedtype ScalarType: ScalarProtocol

    var included: Included { get }
    var excluded: Excluded { get }
    var scalar: ScalarType { get }
}

public struct Vector<Bases: BasisChain, S: Storage>: VectorProtocol, _Accumulable {
    @usableFromInline var storage: S

    @inlinable public init(storage: S = .init()) { self.storage = storage }

    @inlinable public var included: Vector<Bases.Tail, S.Included> { .init(storage: storage.included) }
    @inlinable public var excluded: Vector<Bases.Tail, S.Excluded> { .init(storage: storage.excluded) }
    @inlinable public var scalar: S.ScalarType { storage.scalar }
}

extension VectorProtocol where Self: _Accumulable, Included: _Accumulable, Excluded: _Accumulable {
    @inlinable func add<O: Storage>(to out: inout O) {
        guard !(out is Empty) else { return }

        guard Bases.self != EndBasisChain.self else {
            if O.ScalarType.self != Never.self, ScalarType.self != Never.self {
                out.scalar.value += scalar.value
            }
            return
        }

        included.add(to: &out.included)
        excluded.add(to: &out.excluded)
    }
    @inlinable func subtract<O: Storage>(from out: inout O) {
        guard !(out is Empty) else { return }

        guard Bases.self != EndBasisChain.self else {
            if O.ScalarType.self != Never.self, ScalarType.self != Never.self {
                out.scalar.value += scalar.value
            }
            return
        }

        included.subtract(from: &out.included)
        excluded.subtract(from: &out.excluded)
    }
}
