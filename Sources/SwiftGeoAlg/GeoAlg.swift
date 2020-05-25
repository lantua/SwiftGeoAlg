//
//  GeoAlg.swift
//  
//
//  Created by Natchanon Luangsomboon on 25/5/2563 BE.
//

import Foundation

public struct GABasis: Algebra {
    public static var metricSignature: (positive: BasisStorage, zero: BasisStorage, negative: BasisStorage) { (0, 0, 0x7) }
}

public typealias GeometricAlgebra = MultiVector<GABasis>

public extension GeometricAlgebra {
    static var e1: GeometricAlgebra { .init(terms: [1 << 0: 1]) }
    static var e2: GeometricAlgebra { .init(terms: [1 << 1: 1]) }
    static var e3: GeometricAlgebra { .init(terms: [1 << 2: 1]) }
}
