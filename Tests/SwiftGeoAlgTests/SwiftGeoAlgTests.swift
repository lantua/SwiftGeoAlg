import XCTest
import SwiftGeoAlg

final class SwiftGeoAlgTests: XCTestCase {
    func testMemoryUsage() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        XCTAssertEqual(MemoryLayout<Vector0>.size, MemoryLayout<ScalarValue>.stride * 1)

        XCTAssertEqual(MemoryLayout<Vector1_1D>.size, MemoryLayout<ScalarValue>.stride * 1)

        XCTAssertEqual(MemoryLayout<Vector1_2D>.size, MemoryLayout<ScalarValue>.stride * 2)
        XCTAssertEqual(MemoryLayout<Vector2_2D>.size, MemoryLayout<ScalarValue>.stride * 1)

        XCTAssertEqual(MemoryLayout<Vector1_3D>.size, MemoryLayout<ScalarValue>.stride * 3)
        XCTAssertEqual(MemoryLayout<Vector2_3D>.size, MemoryLayout<ScalarValue>.stride * 3)
        XCTAssertEqual(MemoryLayout<Vector3_3D>.size, MemoryLayout<ScalarValue>.stride * 1)

        XCTAssertEqual(MemoryLayout<Vector1_4D>.size, MemoryLayout<ScalarValue>.stride * 4)
        XCTAssertEqual(MemoryLayout<Vector2_4D>.size, MemoryLayout<ScalarValue>.stride * 6)
        XCTAssertEqual(MemoryLayout<Vector3_4D>.size, MemoryLayout<ScalarValue>.stride * 4)
        XCTAssertEqual(MemoryLayout<Vector4_4D>.size, MemoryLayout<ScalarValue>.stride * 1)

        XCTAssertEqual(MemoryLayout<Vector1_5D>.size, MemoryLayout<ScalarValue>.stride * 5)
        XCTAssertEqual(MemoryLayout<Vector2_5D>.size, MemoryLayout<ScalarValue>.stride * 10)
        XCTAssertEqual(MemoryLayout<Vector3_5D>.size, MemoryLayout<ScalarValue>.stride * 10)
        XCTAssertEqual(MemoryLayout<Vector4_5D>.size, MemoryLayout<ScalarValue>.stride * 5)
        XCTAssertEqual(MemoryLayout<Vector5_5D>.size, MemoryLayout<ScalarValue>.stride * 1)

        XCTAssertEqual(MemoryLayout<Vector1_6D>.size, MemoryLayout<ScalarValue>.stride * 6)
        XCTAssertEqual(MemoryLayout<Vector2_6D>.size, MemoryLayout<ScalarValue>.stride * 15)
        XCTAssertEqual(MemoryLayout<Vector3_6D>.size, MemoryLayout<ScalarValue>.stride * 20)
        XCTAssertEqual(MemoryLayout<Vector4_6D>.size, MemoryLayout<ScalarValue>.stride * 15)
        XCTAssertEqual(MemoryLayout<Vector5_6D>.size, MemoryLayout<ScalarValue>.stride * 6)
        XCTAssertEqual(MemoryLayout<Vector6_6D>.size, MemoryLayout<ScalarValue>.stride * 1)

        XCTAssertEqual(MemoryLayout<Vector1_7D>.size, MemoryLayout<ScalarValue>.stride * 7)
        XCTAssertEqual(MemoryLayout<Vector2_7D>.size, MemoryLayout<ScalarValue>.stride * 21)
        XCTAssertEqual(MemoryLayout<Vector3_7D>.size, MemoryLayout<ScalarValue>.stride * 35)
        XCTAssertEqual(MemoryLayout<Vector4_7D>.size, MemoryLayout<ScalarValue>.stride * 35)
        XCTAssertEqual(MemoryLayout<Vector5_7D>.size, MemoryLayout<ScalarValue>.stride * 21)
        XCTAssertEqual(MemoryLayout<Vector6_7D>.size, MemoryLayout<ScalarValue>.stride * 7)
        XCTAssertEqual(MemoryLayout<Vector7_7D>.size, MemoryLayout<ScalarValue>.stride * 1)
    }

    func testMultiply() {
        do {
            let a = Vector2_4D.included(.excluded(.included(1.0)))
            let b = Vector2_4D.excluded(.included(.excluded(.included(1.0))))
            let c = Vector1_4D.included(1.0)

            do {
                var result = Vector4_5D()
                result.add(productOf: a, b, bases: Bases.self, filter: OuterProduct.self)
                XCTAssertEqual(result.included.included.included.included.scalar, -1)
            }
            do {
                var result = Vector4_4D()
                result.add(productOf: b, a, bases: Bases.self, filter: OuterProduct.self)
                XCTAssertEqual(result.included.included.included.included.scalar, -1)
            }

            do {
                var result = Vector4D()
                result.add(productOf: a, c, bases: Bases.self, filter: OuterProduct.self)
                XCTAssertEqual(result.scalar, 0)
                result.reset()
                result.add(productOf: b, c, bases: Bases.self, filter: OuterProduct.self)
                XCTAssertEqual(result.included.included.excluded.included.scalar, 1)
                result.reset()
                result.add(productOf: c, b, bases: Bases.self, filter: OuterProduct.self)
                XCTAssertEqual(result.included.included.excluded.included.scalar, 1)
            }
        }

        do {
            let a = Vector1_3D.init(included: 1.0, excluded: .excluded(.included(2.0)))
            let b = Vector1_1D.included(1.0)

            var result = Vector2_3D()
            result.add(productOf: a, b, bases: Bases.self, filter: OuterProduct.self)
            XCTAssertEqual(result.included.excluded.included.scalar, -2)
        }

        do {
            let a = Vector1_5D.included(1.0), b = Vector1_5D.excluded(.included(4.0))
            var result = Vector2_5D()
            result.add(productOf: a, b, bases: Bases.self, filter: OuterProduct.self)
            XCTAssertEqual(result.included.included.scalar, 4)
        }
    }

    func testPerf() {
        var result = Vector5_5D()
        let a = Vector3_5D.included(.included(.included(1.0))), b = Vector2_5D.excluded(.excluded(.excluded(.included(.included(4.0)))))

        measure {
            for _ in 0..<10000 {
                result.foo(productOf: a, b, bases: Bases.self, filter: OuterProduct.self)
            }
        }

        print(result)
    }

    static var allTests = [
        ("testMemoryUsage", testMemoryUsage),
    ]
}

typealias Value = Double
typealias Bases = BasisLink<PositiveBasis, BasisLink<PositiveBasis, BasisLink<PositiveBasis, BasisLink<PositiveBasis, BasisLink<NegativeBasis, EndBasisChain>>>>>

extension ComputableStorage {
    //@_specialize(exported: true, where Self == Vector5_5D, L == Vector3_5D, R == Vector2_5D, BC == BasisLink<PositiveBasis, BasisLink<PositiveBasis, BasisLink<PositiveBasis, BasisLink<PositiveBasis, BasisLink<NegativeBasis, EndBasisChain>>>>>, PF == OuterProduct)
    //@inlinable
    mutating func foo<L, R, BC, PF>(productOf lhs: L, _ rhs: R, bases: BC.Type, filter: PF.Type) where L: Storage, R: Storage, BC: BasisChain, PF: ProductFilter {
        add(productOf: lhs, rhs, bases: BC.self, filter: PF.self)
    }

}
