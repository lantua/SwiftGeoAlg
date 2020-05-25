//
//  File.swift
//  
//
//  Created by Natchanon Luangsomboon on 25/5/2563 BE.
//

import Foundation

public struct GABasis: Basis, CustomDebugStringConvertible {
    private var bases = 0

    public init() { }
    fileprivate init(bases: Int) {
        self.bases = bases
    }

    public var grade: Int { bases.nonzeroBitCount }

    public static var positiveBases: Int { 0 }
    public static var negativeBases: Int { 0xff }
    public static var zeroBases: Int { 0 }

    public var debugDescription: String {
        var values: Set<Int> = []
        var current = 0, bases = self.bases

        while bases != 0 {
            if !bases.isMultiple(of: 2) {
                values.insert(current)
            }

            current += 1
            bases >>= 1
        }

        return "\(values.sorted())"
    }
}

public typealias GeometricAlgebra = MultiVector<GABasis>

public extension GeometricAlgebra {
    static var e1: GeometricAlgebra { .init(terms: [1 << 0: 1]) }
    static var e2: GeometricAlgebra { .init(terms: [1 << 1: 1]) }
    static var e3: GeometricAlgebra { .init(terms: [1 << 2: 1]) }
}
