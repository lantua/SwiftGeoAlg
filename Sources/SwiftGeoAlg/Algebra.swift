//
//  Algebra.swift
//  
//
//  Created by Natchanon Luangsomboon on 28/5/2563 BE.
//

public enum Algebra<Bases: Basis> {
    public struct Vector<S: Storage> {
        @usableFromInline var storage: S

        @inlinable public init(storage: S = .init()) { self.storage = storage }

        #warning("Todo: Redo accessor")
        public var included: S.Included { storage.included }
        public var excluded: S.Excluded { storage.excluded }
        public var scalar: ScalarValue { storage.scalar }
    }
    public struct Product<S1: Storage, S2: Storage, PF: Multiplier> {
        @usableFromInline var storage1: S1, storage2: S2

        @inlinable init(storage1: S1, storage2: S2) {
            self.storage1 = storage1
            self.storage2 = storage2
        }
    }
}

public extension Algebra.Vector {
    @inlinable static func +=<L>(lhs: inout Algebra.Vector<L>, rhs: Self) where L: Storage {
        lhs.storage.add(rhs.storage)
    }
    @inlinable static func -=<L>(lhs: inout Algebra.Vector<L>, rhs: Self) where L: Storage {
        lhs.storage.subtract(rhs.storage)
    }
}

public extension Algebra.Product {
    @inlinable static func +=<L>(lhs: inout Algebra.Vector<L>, rhs: Self) where L: Storage {
        PF.multiply(rhs.storage1, rhs.storage2, into: &lhs.storage, bases: Bases.Chain.self)
    }
}

public extension Algebra.Vector where S: ByteZeroable {
    mutating func reset() { storage.reset() }
}
