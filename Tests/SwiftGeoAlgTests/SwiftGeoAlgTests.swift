import XCTest
import SwiftGeoAlg

final class SwiftGeoAlgTests: XCTestCase {
    func testMemoryUsage() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        XCTAssertEqual(MemoryLayout<Storage1D.Grade1>.size, MemoryLayout<ScalarValue>.stride * 1)

        XCTAssertEqual(MemoryLayout<Storage2D.Grade1>.size, MemoryLayout<ScalarValue>.stride * 2)
        XCTAssertEqual(MemoryLayout<Storage2D.Grade2>.size, MemoryLayout<ScalarValue>.stride * 1)

        XCTAssertEqual(MemoryLayout<Storage3D.Grade1>.size, MemoryLayout<ScalarValue>.stride * 3)
        XCTAssertEqual(MemoryLayout<Storage3D.Grade2>.size, MemoryLayout<ScalarValue>.stride * 3)
        XCTAssertEqual(MemoryLayout<Storage3D.Grade3>.size, MemoryLayout<ScalarValue>.stride * 1)

        XCTAssertEqual(MemoryLayout<Storage4D.Grade1>.size, MemoryLayout<ScalarValue>.stride * 4)
        XCTAssertEqual(MemoryLayout<Storage4D.Grade2>.size, MemoryLayout<ScalarValue>.stride * 6)
        XCTAssertEqual(MemoryLayout<Storage4D.Grade3>.size, MemoryLayout<ScalarValue>.stride * 4)
        XCTAssertEqual(MemoryLayout<Storage4D.Grade4>.size, MemoryLayout<ScalarValue>.stride * 1)

        XCTAssertEqual(MemoryLayout<Storage5D.Grade1>.size, MemoryLayout<ScalarValue>.stride * 5)
        XCTAssertEqual(MemoryLayout<Storage5D.Grade2>.size, MemoryLayout<ScalarValue>.stride * 10)
        XCTAssertEqual(MemoryLayout<Storage5D.Grade3>.size, MemoryLayout<ScalarValue>.stride * 10)
        XCTAssertEqual(MemoryLayout<Storage5D.Grade4>.size, MemoryLayout<ScalarValue>.stride * 5)
        XCTAssertEqual(MemoryLayout<Storage5D.Grade5>.size, MemoryLayout<ScalarValue>.stride * 1)
    }

    func testMultiply() {
        do {
            let a = Vector<Storage4D.Grade2>(storage: .included(.excluded(.included(1.0))))
            let b = Vector<Storage4D.Grade2>(storage: .excluded(.included(.excluded(.included(1.0)))))
            let c = Vector<Storage4D.Grade1>(storage: .included(1.0))

            /* ⊛•⌋⌊∧ */

            do {
                var result = Vector<Storage5D.Grade4>()
                result += a ∧ b
                XCTAssertEqual(result.included.included.included.included.scalar, -1)
            }
            do {
                var result = Vector<Storage4D.Grade4>()
                result += b ∧ a
                XCTAssertEqual(result.included.included.included.included.scalar, -1)
            }

            do {
                var result = Vector<Storage4D.Full>()
                result += a ∧ c
                XCTAssertEqual(result.excluded.excluded.excluded.excluded.scalar, 0)
                result.reset()
                result += b ∧ c
                XCTAssertEqual(result.included.included.excluded.included.scalar, 1)
                result.reset()
                result += c ∧ b
                XCTAssertEqual(result.included.included.excluded.included.scalar, 1)
            }
        }

        do {
            let a = Vector<Storage3D.Grade1>(storage: .init(included: 1.0, excluded: .excluded(.included(2.0))))
            let b = Vector<Storage1D.Grade1>(storage: .included(1.0))

            var result = Vector<Storage3D.Grade2>()
            result += a ∧ b
            XCTAssertEqual(result.included.excluded.included.scalar, -2)
        }

        do {
            let a = Vector<Storage5D.Grade1>(storage: .included(1.0))
            let b = Vector<Storage5D.Grade1>(storage: .excluded(.included(4.0)))
            var result = Vector<Storage5D.Grade2>()
            result += a ∧ b
            XCTAssertEqual(result.included.included.scalar, 4)
        }
    }

    func testPerfMultiply() {
        var result = Vector<Storage5D.Grade5>()
        let a = Vector<Storage5D.Grade3>(storage: .included(.included(.included(1.0))))
        let b = Vector<Storage5D.Grade2>(storage: .excluded(.excluded(.excluded(.included(.included(4.0))))))

        measure {
            for _ in 0..<500000 {
                result += a ∧ b
            }
        }

        print(result)
    }
    func testPerfAdd() {
        var result = Vector<Storage5D.Grade3>()
        let a = Vector<Storage5D.Grade3>(storage: .included(.included(.included(1.0))))

        measure {
            for _ in 0..<500000 {
                result += a
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

typealias Vector<S: Storage> = SwiftGeoAlg.Vector<E.Chain, S>
