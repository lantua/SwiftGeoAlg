//
//  Operators.swift
//  
//
//  Created by Natchanon Luangsomboon on 25/5/2563 BE.
//

precedencegroup ScalarMultiplicationPrecedence {
    higherThan: AdditionPrecedence
}
precedencegroup InnerMultiplicationPrecedence {
    higherThan: AdditionPrecedence
}
precedencegroup OuterMultiplicationPrecedence {
    higherThan: AdditionPrecedence
    associativity: left
}

infix operator ⊛: ScalarMultiplicationPrecedence // Should be `∗`, but it could be visually confused with normal `*`.
infix operator •: InnerMultiplicationPrecedence
infix operator ⌋: InnerMultiplicationPrecedence
infix operator ⌊: InnerMultiplicationPrecedence
infix operator ∧: OuterMultiplicationPrecedence

public protocol Multiplier {
    static func add<L, R, O, BC>(productOf lhs: L, _ rhs: R, to out: inout O, bases: BC.Type) where L: Storage, R: Storage, O: Storage, BC: BasisChain
    static func subtract<L, R, O, BC>(productOf lhs: L, _ rhs: R, from out: inout O, bases: BC.Type) where L: Storage, R: Storage, O: Storage, BC: BasisChain
}

public extension Algebra.Vector {
    @inlinable static func ⊛<O>(lhs: Self, rhs: Algebra.Vector<O>) -> Algebra.Product<S, O, ScalarProduct> where O: Storage {
        .init(storage1: lhs.storage, storage2: rhs.storage)
    }
    @inlinable static func •<O>(lhs: Self, rhs: Algebra.Vector<O>) -> Algebra.Product<S, O, FatDotProduct> where O: Storage {
        .init(storage1: lhs.storage, storage2: rhs.storage)
    }
    @inlinable static func ⌋<O>(lhs: Self, rhs: Algebra.Vector<O>) -> Algebra.Product<S, O, LeftInnerProduct> where O: Storage {
        .init(storage1: lhs.storage, storage2: rhs.storage)
    }
    @inlinable static func ⌊<O>(lhs: Self, rhs: Algebra.Vector<O>) -> Algebra.Product<O, S, LeftInnerProduct> where O: Storage {
        .init(storage1: rhs.storage, storage2: lhs.storage)
    }
    @inlinable static func ∧<O>(lhs: Self, rhs: Algebra.Vector<O>) -> Algebra.Product<S, O, OuterProduct> where O: Storage {
        .init(storage1: lhs.storage, storage2: rhs.storage)
    }
}
