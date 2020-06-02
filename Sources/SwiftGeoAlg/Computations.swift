//
//  Computations.swift
//  
//
//  Created by Natchanon Luangsomboon on 28/5/2563 BE.
//

extension Storage {
    @inlinable mutating func add<O>(_ other: O) where O: Storage {
        guard !(self is Empty) else { return }

        if Included.self != Empty.self {
            included.add(other.included)
        }
        if Excluded.self != Empty.self {
            excluded.add(other.excluded)
        }
    }

    @inlinable mutating func subtract<O>(_ other: O) where O: Storage {
        guard !(self is Empty) else { return }
        
        if Included.self != Empty.self {
            included.subtract(other.included)
        }
        if Excluded.self != Empty.self {
            excluded.subtract(other.excluded)
        }
    }
}
