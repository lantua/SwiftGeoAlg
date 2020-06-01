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
            let a = Alg.Vector<Vector2_4D>(storage: .included(.excluded(.included(1.0))))
            let b = Alg.Vector<Vector2_4D>(storage: .excluded(.included(.excluded(.included(1.0)))))
            let c = Alg.Vector<Vector1_4D>(storage: .included(1.0))

            /* ⊛•⌋⌊∧ */

            do {
                var result = Alg.Vector<Vector4_5D>()
                result += a ∧ b
                XCTAssertEqual(result.included.included.included.included.scalar, -1)
            }
            do {
                var result = Alg.Vector<Vector4_4D>()
                result += b ∧ a
                XCTAssertEqual(result.included.included.included.included.scalar, -1)
            }

            do {
                var result = Alg.Vector<Vector4D>()
                result += a ∧ c
                XCTAssertEqual(result.scalar, 0)
                result.reset()
                result += b ∧ c
                XCTAssertEqual(result.included.included.excluded.included.scalar, 1)
                result.reset()
                result += c ∧ b
                XCTAssertEqual(result.included.included.excluded.included.scalar, 1)
            }
        }

        do {
            let a = Alg.Vector<Vector1_3D>(storage: .init(included: 1.0, excluded: .excluded(.included(2.0))))
            let b = Alg.Vector<Vector1_1D>(storage: .included(1.0))

            var result = Alg.Vector<Vector2_3D>()
            result += a ∧ b
            XCTAssertEqual(result.included.excluded.included.scalar, -2)
        }

        do {
            let a = Alg.Vector<Vector1_5D>(storage: .included(1.0))
            let b = Alg.Vector<Vector1_5D>(storage: .excluded(.included(4.0)))
            var result = Alg.Vector<Vector2_5D>()
            result += a ∧ b
            XCTAssertEqual(result.included.included.scalar, 4)
        }
    }

    func testPerf() {
        var result = Alg.Vector<Vector5_5D>()
        let a = Alg.Vector<Vector3_5D>(storage: .included(.included(.included(1.0))))
        let b = Alg.Vector<Vector2_5D>(storage: .excluded(.excluded(.excluded(.included(.included(4.0))))))

        measure {
            for _ in 0..<100000 {
                result += a ∧ b
            }
        }

        print(result)
    }

    static var allTests = [
        ("testMemoryUsage", testMemoryUsage),
    ]
}

typealias Value = Double

enum A: NegativeBasis { public typealias Next = NoBasis }
enum B: PositiveBasis { public typealias Next = A }
enum C: PositiveBasis { public typealias Next = B }
enum D: PositiveBasis { public typealias Next = C }
enum E: PositiveBasis { public typealias Next = D }

typealias Alg = Algebra<E>
