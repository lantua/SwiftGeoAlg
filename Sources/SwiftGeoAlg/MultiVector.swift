//
//  File.swift
//  
//
//  Created by Natchanon Luangsomboon on 25/5/2563 BE.
//

import Foundation

public protocol Basis: Hashable {
    static var positiveBases: Int { get }
    static var negativeBases: Int { get }
    static var zeroBases: Int { get }
}

public struct MultiVector<B: Basis> {
    public typealias Scalar = Double
    fileprivate var terms: [Int: Scalar]

    mutating func removeZeroTerms(threshold: Scalar) {
        terms = terms.filter { $0.value.magnitude >= threshold }
    }

    public init(terms: [Int: Scalar]) {
        self.terms = terms
    }
}

infix operator ⌋: InnerProduct
infix operator ⌊: InnerProduct
infix operator ∧: OuterProduct

precedencegroup InnerProduct {
    higherThan: MultiplicationPrecedence
}

precedencegroup OuterProduct {
    higherThan: InnerProduct
}

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

extension MultiVector {
    public static func *(lhs: MultiVector, rhs: MultiVector) -> MultiVector {
        mul(lhs, rhs, include: { _, _ in true })
    }
    /// Outer product
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

    public static func scalarProduct(lhs: MultiVector, rhs: MultiVector) -> MultiVector {
        mul(lhs, rhs, include: { $0 == $1 })
    }
    public static func fatDot(lhs: MultiVector, rhs: MultiVector) -> MultiVector {
        mul(lhs, rhs, include: { ~$0 & $1 == 0 || $0 & ~$1 == 0 })
    }

    private static func mul(_ lhs: MultiVector, _ rhs: MultiVector, include: (Int, Int) -> Bool) -> MultiVector {
        var terms: [Int: Double] = [:]
        for (k1, v1) in lhs.terms {
            for (k2, v2) in rhs.terms where include(k1, k2) {
                let duplicatedBases = k1 & k2
                guard duplicatedBases & B.zeroBases == 0 else {
                    continue
                }
                let k = k1 ^ k2
                if (duplicatedBases & B.negativeBases).nonzeroBitCount.isMultiple(of: 2) != self.flip(k1, k2) {
                    terms[k, default: 0] += v1 * v2
                } else {
                    terms[k, default: 0] -= v1 * v2
                }
            }
        }

        return MultiVector(terms: terms)
    }

    private static func flip(_ lhs: Int, _ rhs: Int) -> Bool {
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
