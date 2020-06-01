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

@inlinable public
func ⊛<BC, S1, S2>(lhs: Algebra<BC>.Vector<S1>, rhs: Algebra<BC>.Vector<S2>) -> Algebra<BC>.Product<S1, S2, ScalarProduct> where BC: Basis, S1: Storage, S2: Storage {
    .init(storage1: lhs.storage, storage2: rhs.storage)
}

@inlinable public
func •<BC, S1, S2>(lhs: Algebra<BC>.Vector<S1>, rhs: Algebra<BC>.Vector<S2>) -> Algebra<BC>.Product<S1, S2, FatDotProduct> where BC: Basis, S1: Storage, S2: Storage {
    .init(storage1: lhs.storage, storage2: rhs.storage)
}

@inlinable public
func ⌋<BC, S1, S2>(lhs: Algebra<BC>.Vector<S1>, rhs: Algebra<BC>.Vector<S2>) -> Algebra<BC>.Product<S1, S2, LeftInnerProduct> where BC: Basis, S1: Storage, S2: Storage {
    .init(storage1: lhs.storage, storage2: rhs.storage)
}

@inlinable public
func ⌊<BC, S1, S2>(lhs: Algebra<BC>.Vector<S1>, rhs: Algebra<BC>.Vector<S2>) -> Algebra<BC>.Product<S2, S1, LeftInnerProduct> where BC: Basis, S1: Storage, S2: Storage {
    .init(storage1: rhs.storage, storage2: lhs.storage)
}

@inlinable public
func ∧<BC, S1, S2>(lhs: Algebra<BC>.Vector<S1>, rhs: Algebra<BC>.Vector<S2>) -> Algebra<BC>.Product<S1, S2, OuterProduct> where BC: Basis, S1: Storage, S2: Storage {
    .init(storage1: lhs.storage, storage2: rhs.storage)
}
