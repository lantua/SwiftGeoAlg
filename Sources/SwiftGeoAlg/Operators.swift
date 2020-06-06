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
    associatedtype Bases: BasisChain

    static func +=<O>(lhs: inout Vector<Bases, O>, rhs: Self)
    static func -=<O>(lhs: inout Vector<Bases, O>, rhs: Self)
}

@inlinable public func ∧<L, R>(lhs: L, rhs: R) -> OuterProduct<L, R> { .init(lhs, rhs) }
@inlinable public prefix func -<V>(base: V) -> Negated<V> { .init(base: base) }
