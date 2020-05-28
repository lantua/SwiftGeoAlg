//
//  GenericChain.swift
//  
//
//  Created by Natchanon Luangsomboon on 27/5/2563 BE.
//

import Foundation

/// Linked list of Bases, most algorithms require that it also conforms to ONE-AND-ONLY-ONE of `PositiveBasis`, `NegativeBasis`, `ZeroBasis.`
public protocol Basis {
    associatedtype Next: Basis
}
public protocol PositiveBasis: Basis { }
public protocol NegativeBasis: Basis { }
public protocol ZeroBasis: Basis { }

// MARK: ProductChain

public protocol ProductChain {
    associatedtype Next: ProductChain
    associatedtype Storage: VectorStorage = Empty
}

