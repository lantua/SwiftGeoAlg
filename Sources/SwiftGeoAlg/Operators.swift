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

@usableFromInline protocol _Accumulable: Accumulable {
    func add<O: Storage>(to out: inout O)
    func subtract<O: Storage>(from out: inout O)
}
extension _Accumulable {
    @inlinable public static func +=<O>(lhs: inout Vector<Bases, O>, rhs: Self) {
        rhs.add(to: &lhs.storage)
    }
    @inlinable public static func -=<O>(lhs: inout Vector<Bases, O>, rhs: Self) {
        rhs.subtract(from: &lhs.storage)
    }
}

@inlinable public func ∧<L, R>(lhs: L, rhs: R) -> OuterProduct<L, R> { .init(lhs, rhs) }
