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

    static func +=<O: Storage>(lhs: inout Vector<Chain, O>, rhs: Self)
    static func -=<O: Storage>(lhs: inout Vector<Chain, O>, rhs: Self)
}

public extension Vector {
    @inlinable static func ∧<O>(lhs: Self, rhs: Vector<Chain, O>) -> OuterProduct<S, O, Chain> where O: Storage {
        .init(lhs.storage, rhs.storage)
    }
}
