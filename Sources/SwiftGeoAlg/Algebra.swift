//
//  Algebra.swift
//  
//
//  Created by Natchanon Luangsomboon on 28/5/2563 BE.
//

public struct Vector<Chain: BasisChain, S: Storage> {
    @usableFromInline var storage: S

    @inlinable public init(storage: S = .init()) { self.storage = storage }

    #warning("Todo: Redo accessor")
    @inlinable public var included: Vector<Chain.Tail, S.Included> { .init(storage: storage.included) }
    @inlinable public var excluded: Vector<Chain.Tail, S.Excluded> { .init(storage: storage.excluded) }
    @inlinable public var scalar: ScalarValue { storage.scalar.value }
}

extension Vector: Accumulable {
    @inlinable public static func +=<O>(lhs: inout Vector<Chain, O>, rhs: Self) where O: Storage {
        rhs.add(into: &lhs.storage)
    }
    @inlinable public static func -=<O>(lhs: inout Vector<Chain, O>, rhs: Self) where O: Storage {
        rhs.subtract(from: &lhs.storage)
    }

    @inlinable func add<O: Storage>(into out: inout O) {
        guard !(out is Empty), !(storage is Empty) else { return }

        guard Chain.self != EndBasisChain.self else {
            if O.ScalarType.self != Never.self, S.ScalarType.self != Never.self {
                out.scalar.value += scalar.value
            }
            return
        }

        included.add(into: &out.included)
        excluded.add(into: &out.excluded)
    }
    @inlinable func subtract<O: Storage>(from out: inout O) {
        guard !(out is Empty), !(storage is Empty) else { return }

        guard Chain.self != EndBasisChain.self else {
            if O.ScalarType.self != Never.self, S.ScalarType.self != Never.self {
                out.scalar.value += scalar.value
            }
            return
        }

        included.subtract(from: &out.included)
        excluded.subtract(from: &out.excluded)
    }
}
