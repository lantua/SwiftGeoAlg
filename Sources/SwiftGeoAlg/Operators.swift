//
//  Operators.swift
//  
//
//  Created by Natchanon Luangsomboon on 25/5/2563 BE.
//

infix operator ⌋: InnerProductPrecedence
infix operator ⌊: InnerProductPrecedence
infix operator ∧: OuterProductPrecedence

precedencegroup InnerProductPrecedence {
    higherThan: MultiplicationPrecedence
}

precedencegroup OuterProductPrecedence {
    higherThan: MultiplicationPrecedence
    associativity: left
}
