//
//  Algebra.swift
//  
//
//  Created by Natchanon Luangsomboon on 28/5/2563 BE.
//

import Foundation

public protocol Basis {
    associatedtype Next: Basis
    associatedtype Sign: BasisSign
    associatedtype Chain: BasisChain = _BasisChain<Self>
}
public typealias _BasisChain<B: Basis> = MidBasisChain<B.Sign, B.Next.Chain>
public protocol PositiveBasis: Basis where Sign == Positive { }
public protocol NegativeBasis: Basis where Sign == Negative { }
public protocol ZeroBasis: Basis where Sign == Zero { }

public enum NoBasis: ZeroBasis {
    public typealias Next = Self
    public typealias Chain = EndBasisChain
}

public protocol BasisChain {
    associatedtype Tail: BasisChain
    associatedtype Current: BasisSign
}
public enum EndBasisChain: BasisChain {
    public typealias Tail = Self
    public typealias Current = Zero
}
public enum MidBasisChain<Current: BasisSign, Tail: BasisChain>: BasisChain { }

public protocol BasisSign { }
public enum Positive: BasisSign { }
public enum Negative: BasisSign { }
public enum Zero: BasisSign { }

@usableFromInline
enum ProductType {
    case outer, leftInner, fatDot, scalar
}

public enum Algebra<Bases: Basis> {
    public struct Vector<S: Storage> {
        @usableFromInline var storage: S

        public init(storage: S = .init()) { self.storage = storage }

        #warning("Todo: Redo accessor")
        public var included: S.Included { storage.included }
        public var excluded: S.Excluded { storage.excluded }
        public var scalar: ScalarValue { storage.scalar }
    }
    public struct Product<S1: Storage, S2: Storage> {
        @usableFromInline var type: ProductType, storage1: S1, storage2: S2

        @inlinable
        init(type: ProductType, storage1: S1, storage2: S2) {
            self.type = type
            self.storage1 = storage1
            self.storage2 = storage2
        }
    }
}

public extension Algebra.Vector {
    @inlinable static func +=<Other: Storage>(lhs: inout Self, rhs: Algebra.Vector<Other>) {
        lhs.storage.add(rhs.storage)
    }

    @inlinable static func -=<Other: Storage>(lhs: inout Self, rhs: Algebra.Vector<Other>) {
        lhs.storage.subtract(rhs.storage)
    }

    @inlinable static func +=<O1: Storage, O2: Storage>(lhs: inout Self, rhs: Algebra.Product<O1, O2>) {
        switch rhs.type {
        case .outer: lhs.storage.add(productOf: rhs.storage1, rhs.storage2, bases: Bases.Chain.self, filter: OuterProduct.self)
        case .leftInner: lhs.storage.add(productOf: rhs.storage1, rhs.storage2, bases: Bases.Chain.self, filter: LeftInnerProduct.self)
        case .scalar: lhs.storage.add(productOf: rhs.storage1, rhs.storage2, bases: Bases.Chain.self, filter: ScalarProduct.self)
        case .fatDot: lhs.storage.add(productOf: rhs.storage1, rhs.storage2, bases: Bases.Chain.self, filter: FatDotProduct.self)
        }
    }
}

public extension Algebra.Vector where S: ByteZeroable {
    mutating func reset() { storage.reset() }
}
