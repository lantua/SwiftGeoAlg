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
        public var included: Algebra<Bases.Next>.Vector<S.Included> { .init(storage: storage.included) }
        public var excluded: Algebra<Bases.Next>.Vector<S.Excluded> { .init(storage: storage.excluded) }
        public var scalar: ScalarValue { storage.scalar.value }
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

public extension Algebra.Vector where S: ByteZeroable {
    mutating func reset() { storage.reset() }
}
