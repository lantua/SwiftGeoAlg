//
//  Computations.swift
//  
//
//  Created by Natchanon Luangsomboon on 28/5/2563 BE.
//

extension Storage {
    @inlinable mutating func add<O>(_ other: O) where O: Storage {
        guard !(self is Empty), !(other is Empty) else { return }

        included.add(other.included)
        excluded.add(other.excluded)
    }

    @inlinable mutating func subtract<O>(_ other: O) where O: Storage {
        guard !(self is Empty), !(other is Empty) else { return }

        included.subtract(other.included)
        excluded.subtract(other.excluded)
    }
}
