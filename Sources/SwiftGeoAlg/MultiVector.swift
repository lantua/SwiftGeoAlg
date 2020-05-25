//
//  File.swift
//  
//
//  Created by Natchanon Luangsomboon on 25/5/2563 BE.
//

import Foundation

public typealias BasisStorage = UInt8

public protocol Algebra: Hashable {
    // Bitmasks representing positive/negative/zero bases. These bitmask must be mutually exclusive.
    static var metricSignature: (positive: BasisStorage, zero: BasisStorage, negative: BasisStorage) { get }
}

public struct MultiVector<Alg: Algebra> {
    public typealias Scalar = Double

    var terms: [BasisStorage: Scalar]

    mutating func removeZeroTerms(threshold: Scalar) {
        terms = terms.filter { $0.value.magnitude >= threshold }
    }

    public static subscript(value: Int) -> Int {

    }
}

// MARK: Conformances

extension MultiVector: AdditiveArithmetic {
    public static var zero: MultiVector { .init(terms: [:]) }

    public static func += (lhs: inout MultiVector, rhs: MultiVector) {
        lhs.terms.merge(rhs.terms, uniquingKeysWith: +)
    }
    public static func -= (lhs: inout MultiVector, rhs: MultiVector) {
        lhs.terms.merge(rhs.terms.mapValues(-), uniquingKeysWith: +)
    }
    public static func +(lhs: MultiVector, rhs: MultiVector) -> MultiVector {
        var lhs = lhs
        lhs += rhs
        return lhs
    }
    public static func -(lhs: MultiVector, rhs: MultiVector) -> MultiVector {
        var lhs = lhs
        lhs -= rhs
        return lhs
    }
}

extension MultiVector: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    public init(floatLiteral value: MultiVector.Scalar) {
        self.init(terms: [0: value])
    }
    public init(integerLiteral value: MultiVector.Scalar.IntegerLiteralType) {
        self.init(floatLiteral: .init(integerLiteral: value))
    }
}

// MARK: Inner/Outer Products

extension MultiVector {
    /// Geometric Product
    public static func *(lhs: MultiVector, rhs: MultiVector) -> MultiVector {
        mul(lhs, rhs, include: { _, _ in true })
    }
    /// Outer Product
    public static func ∧(lhs: MultiVector, rhs: MultiVector) -> MultiVector {
        mul(lhs, rhs, include: { $0 & $1 == 0 })
    }
    /// Left Contraction
    public static func ⌋(lhs: MultiVector, rhs: MultiVector) -> MultiVector {
        mul(lhs, rhs, include: { $0 & ~$1 == 0 })
    }
    /// Right Contraction
    public static func ⌊(lhs: MultiVector, rhs: MultiVector) -> MultiVector {
        mul(lhs, rhs, include: { ~$0 & $1 == 0 })
    }

    private static func mul(_ lhs: MultiVector, _ rhs: MultiVector, include: (BasisStorage, BasisStorage) -> Bool) -> MultiVector {
        var terms: [BasisStorage: Double] = [:]
        for (k1, v1) in lhs.terms {
            for (k2, v2) in rhs.terms where include(k1, k2) {
                let (_, zeroBases, negativeBases) = Alg.metricSignature, duplicatedBases = k1 & k2
                guard duplicatedBases & zeroBases == 0 else {
                    continue
                }
                let k = k1 ^ k2
                if (duplicatedBases & negativeBases).nonzeroBitCount.isMultiple(of: 2) != self.flip(k1, k2) {
                    terms[k, default: 0] += v1 * v2
                } else {
                    terms[k, default: 0] -= v1 * v2
                }
            }
        }

        return MultiVector(terms: terms)
    }

    private static func flip(_ lhs: BasisStorage, _ rhs: BasisStorage) -> Bool {
        var flip = rhs.nonzeroBitCount & 0x2 != 0
        var rhs = rhs, interests = lhs ^ rhs

        while rhs != 0 {
            defer {
                interests >>= 1
                rhs >>= 1
            }

            guard !interests.isMultiple(of: 2),
                (rhs | 1).nonzeroBitCount.isMultiple(of: 2) else {
                    continue
            }

            flip.toggle()
        }

        return flip
    }
}
