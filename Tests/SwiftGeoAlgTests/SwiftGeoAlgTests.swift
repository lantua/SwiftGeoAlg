import XCTest
@testable import SwiftGeoAlg

final class SwiftGeoAlgTests: XCTestCase {
    func testMemoryUsage() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        XCTAssertEqual(MemoryLayout<Algebra.MultiVector>.size, MemoryLayout<Scalar>.stride * 64)

        XCTAssertEqual(MemoryLayout<Algebra.Even>.size, MemoryLayout<Scalar>.stride * 32)
        XCTAssertEqual(MemoryLayout<Algebra.Odd>.size, MemoryLayout<Scalar>.stride * 32)

        XCTAssertEqual(MemoryLayout<Algebra.Grade0>.size, MemoryLayout<Scalar>.stride * 1)
        XCTAssertEqual(MemoryLayout<Algebra.Grade1>.size, MemoryLayout<Scalar>.stride * 6)
        XCTAssertEqual(MemoryLayout<Algebra.Grade2>.size, MemoryLayout<Scalar>.stride * 15)
        XCTAssertEqual(MemoryLayout<Algebra.Grade3>.size, MemoryLayout<Scalar>.stride * 20)
        XCTAssertEqual(MemoryLayout<Algebra.Grade4>.size, MemoryLayout<Scalar>.stride * 15)
        XCTAssertEqual(MemoryLayout<Algebra.Grade5>.size, MemoryLayout<Scalar>.stride * 6)
        XCTAssertEqual(MemoryLayout<Algebra.Grade6>.size, MemoryLayout<Scalar>.stride * 1)
        XCTAssertEqual(MemoryLayout<Algebra.Grade7>.size, MemoryLayout<Scalar>.stride * 0)
        XCTAssertEqual(MemoryLayout<Algebra.Grade8>.size, MemoryLayout<Scalar>.stride * 0)
    }

    static var allTests = [
        ("testMemoryUsage", testMemoryUsage),
    ]
}

enum A: PositiveBasis { }
enum B: PositiveBasis { }
enum C: PositiveBasis { }
enum D: PositiveBasis { }
enum E: NegativeBasis { }
enum F: NegativeBasis { }
typealias Algebra = Bases<A, B, C, Base3<D, E, F>>
