//
//  Algebra.swift
//  
//
//  Created by Natchanon Luangsomboon on 28/5/2563 BE.
//

import Foundation

public protocol Basis {}
public enum PositiveBasis: Basis {}
public enum NegativeBasis: Basis {}
public enum ZeroBasis: Basis {}

/// Uses `EndBasisChain` and `BasisLink`.
/// Convention uses zero, positives, negative bases in this order (negative basis is near `EndBasisChain`).
/// Follows this order to maximize the chance of reusing (optimized) specialization.
public protocol BasisChain {
    associatedtype Next: BasisChain
    associatedtype Current: Basis
}

public enum EndBasisChain: BasisChain {
    public typealias Next = Self
    public typealias Current = ZeroBasis
}

public enum BasisLink<Current: Basis, Next: BasisChain>: BasisChain { }

enum ProductType {
    case outer, leftInner, fatDot, scalar
}

public enum Algebra<Bases: BasisChain> {
    public struct Vector<S: ComputableStorage> {
        var storage: S
    }
    public struct Product<S1: ComputableStorage, S2: ComputableStorage> {
        var type: ProductType, storage1: S1, storage2: S2
    }
}

public extension Algebra.Vector {
    static func +=<Other: ComputableStorage>(lhs: inout Self, rhs: Algebra.Vector<Other>) {
        lhs.storage.add(rhs.storage)
    }

    static func -=<Other: ComputableStorage>(lhs: inout Self, rhs: Algebra.Vector<Other>) {
        lhs.storage.subtract(rhs.storage)
    }

    static func +=<O1: ComputableStorage, O2: ComputableStorage>(lhs: inout Self, rhs: Algebra.Product<O1, O2>) {
        switch rhs.type {
        case .outer: lhs.storage.add(productOf: rhs.storage1, rhs.storage2, bases: Bases.self, filter: OuterProduct.self)
        case .leftInner: lhs.storage.add(productOf: rhs.storage1, rhs.storage2, bases: Bases.self, filter: LeftInnerProduct.self)
        case .scalar: lhs.storage.add(productOf: rhs.storage1, rhs.storage2, bases: Bases.self, filter: ScalarProduct.self)
        case .fatDot: lhs.storage.add(productOf: rhs.storage1, rhs.storage2, bases: Bases.self, filter: FatDotProduct.self)
        }
    }
}
