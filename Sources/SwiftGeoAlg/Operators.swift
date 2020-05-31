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

// Should be `∗`, but it could be visually confused with normal `*`.
infix operator ⊛: ScalarMultiplicationPrecedence
infix operator •: InnerMultiplicationPrecedence
infix operator ⌋: InnerMultiplicationPrecedence
infix operator ⌊: InnerMultiplicationPrecedence
infix operator ∧: OuterMultiplicationPrecedence

public func ⊛<BC, S1, S2>(lhs: Algebra<BC>.Vector<S1>, rhs: Algebra<BC>.Vector<S2>) -> Algebra<BC>.Product<S1, S2> where BC: BasisChain, S1: Storage, S2: Storage {
    .init(type: .scalar, storage1: lhs.storage, storage2: rhs.storage)
}

public func •<BC, S1, S2>(lhs: Algebra<BC>.Vector<S1>, rhs: Algebra<BC>.Vector<S2>) -> Algebra<BC>.Product<S1, S2> where BC: BasisChain, S1: Storage, S2: Storage {
    .init(type: .fatDot, storage1: lhs.storage, storage2: rhs.storage)
}

public func ⌋<BC, S1, S2>(lhs: Algebra<BC>.Vector<S1>, rhs: Algebra<BC>.Vector<S2>) -> Algebra<BC>.Product<S1, S2> where BC: BasisChain, S1: Storage, S2: Storage {
    .init(type: .leftInner, storage1: lhs.storage, storage2: rhs.storage)
}

public func ⌊<BC, S1, S2>(lhs: Algebra<BC>.Vector<S1>, rhs: Algebra<BC>.Vector<S2>) -> Algebra<BC>.Product<S2, S1> where BC: BasisChain, S1: Storage, S2: Storage {
    .init(type: .leftInner, storage1: rhs.storage, storage2: lhs.storage)
}

public func ∧<BC, S1, S2>(lhs: Algebra<BC>.Vector<S1>, rhs: Algebra<BC>.Vector<S2>) -> Algebra<BC>.Product<S1, S2> where BC: BasisChain, S1: Storage, S2: Storage {
    .init(type: .outer, storage1: lhs.storage, storage2: rhs.storage)
}
