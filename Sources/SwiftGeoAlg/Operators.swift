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

public protocol Accumulable {
    associatedtype Chain: BasisChain

    static func +=<B: Basis, O: Storage>(lhs: inout Algebra<B>.Vector<O>, rhs: Self) where B.Chain == Chain
    static func -=<B: Basis, O: Storage>(lhs: inout Algebra<B>.Vector<O>, rhs: Self) where B.Chain == Chain
}

public extension Algebra.Vector {
    @inlinable static func ∧<O>(lhs: Self, rhs: Algebra.Vector<O>) -> OuterProduct<S, O, Bases.Chain> where O: Storage {
        .init(lhs.storage, rhs.storage)
    }
}
