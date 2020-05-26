//
//  MultiVector.swift
//  
//
//  Created by Natchanon Luangsomboon on 25/5/2563 BE.
//

import Foundation

public typealias Scalar = Double

public protocol Algebra: Hashable {
    // Bitmasks representing positive/negative/zero bases. These bitmask must be mutually exclusive.
    static var metricSignature: (positive: BasisStorage, negative: BasisStorage, zero: BasisStorage) { get }
}

public struct BasisStorage: OptionSet, Hashable {
    public var rawValue: UInt8

    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    var count: Int { rawValue.nonzeroBitCount }
}

public struct MultiVector<Alg: Algebra> {

    fileprivate var terms: [BasisStorage: Scalar]

    mutating func removeZeros(threshold: Scalar) {
        terms = terms.filter { $0.value.magnitude > threshold }
    }

    public init(terms: [BasisStorage: Scalar]) {
        self.terms = terms
    }
}

public extension MultiVector {
    var dual: Self {
        let (p, n, z) = Alg.metricSignature
        let bases: BasisStorage = [p, z, n]
        let negative = (bases.count + 1) & 2 == 0
        return self * .init(terms: [bases: negative ? -1 : 1])
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
    public init(floatLiteral value: Scalar) {
        self.init(terms: [.init(): value])
    }
    public init(integerLiteral value: Scalar.IntegerLiteralType) {
        self.init(floatLiteral: .init(integerLiteral: value))
    }
}

// MARK: Inner/Outer Products

extension MultiVector {
    /// Geometric Product
    public static func *(lhs: MultiVector, rhs: MultiVector) -> MultiVector { mul(lhs, rhs) { _, _ in true } }
    public static func dot(lhs: MultiVector, rhs: MultiVector) -> MultiVector { mul(lhs, rhs) { $0 == $1 } }
    /// Outer Product
    public static func ∧(lhs: MultiVector, rhs: MultiVector) -> MultiVector { mul(lhs, rhs) { $0.intersection($1).isEmpty } }

    /// Left Contraction
    public static func ⌋(lhs: MultiVector, rhs: MultiVector) -> MultiVector { mul(lhs, rhs) { $0.isSubset(of: $1) } }
    /// Right Contraction
    public static func ⌊(lhs: MultiVector, rhs: MultiVector) -> MultiVector { mul(lhs, rhs) { $0.isSuperset(of: $1) } }
    public static func /(lhs: MultiVector, rhs: Scalar) -> MultiVector { .init(terms: lhs.terms.mapValues { $0 / rhs }) }

    private static func mul(_ lhs: MultiVector, _ rhs: MultiVector, isIncluded: (BasisStorage, BasisStorage) -> Bool) -> MultiVector {
        let (_, negatives, zeros) = Alg.metricSignature

        var terms: [BasisStorage: Double] = [:]
        for (k1, v1) in lhs.terms {
            for (k2, v2) in rhs.terms where isIncluded(k1, k2) {
                let duplicated = k1.intersection(k2)
                guard duplicated.isDisjoint(with: zeros) else {
                    continue
                }
                let k = k1.symmetricDifference(k2)
                if duplicated.intersection(negatives).count.isMultiple(of: 2) != self.flip(k1, k2) {
                    terms[k, default: 0] += v1 * v2
                } else {
                    terms[k, default: 0] -= v1 * v2
                }
            }
        }

        return MultiVector(terms: terms)
    }

    private static func flip(_ lhs: BasisStorage, _ rhs: BasisStorage) -> Bool {
        var flip = rhs.count & 0x2 != 0, rhs = rhs.rawValue, interests = lhs.rawValue ^ rhs

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
