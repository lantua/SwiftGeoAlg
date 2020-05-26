//
//  CGA.swift
//  
//
//  Created by Natchanon Luangsomboon on 25/5/2563 BE.
//

import Foundation

struct EuclideanCGA3DBasis: Algebra {
    // Low bits for positive bases, high bit for negative
    public static var metricSignature: (positive: BasisStorage, negative: BasisStorage, zero: BasisStorage) { ([.x, .y, .z, .ep], .en, []) }
}

typealias CGA3 = MultiVector<EuclideanCGA3DBasis>

protocol CGA3Composition {
    init(value: CGA3)
}

extension CGA3Composition {
    init?(_ objects: CGA3...) {
        var result = CGA3(terms: [[]: 1])
        for object in objects {
            result = result ∧ object
        }
        result.removeZeros(threshold: 0)
        if result == .init(terms: [:]) {
            return nil
        }
        self.init(value: result)
    }
}

private extension BasisStorage {
    static var x: BasisStorage { .init(rawValue: 1 << 0) }
    static var y: BasisStorage { .init(rawValue: 1 << 1) }
    static var z: BasisStorage { .init(rawValue: 1 << 2) }
    static var ep: BasisStorage { .init(rawValue: 1 << 3) }
    static var en: BasisStorage { .init(rawValue: 1 << 4) }
}

extension CGA3 {
    static var n0: CGA3 { .init(terms: [.en: 0.5, .ep: -0.5]) }
    static var ninf: CGA3 { .init(terms: [.en: 1, .ep: 1]) }
}

public struct Point {
    var value: CGA3
    init(x: Scalar, y: Scalar, z: Scalar) {
        let normSq = x*x + y*y + z*z
        value = CGA3(terms: [.x: x, .y: y, .z: z, .ep: (normSq - 1) / 2, .en: (normSq + 1) / 2])
    }
}

public struct Line: CGA3Composition { var value: CGA3 }
public struct Plane: CGA3Composition { var value: CGA3 }
public struct Circle: CGA3Composition { var value: CGA3 }
public struct Sphere: CGA3Composition { var value: CGA3 }

public extension Line {
    init?(passing p1: Point, _ p2: Point) { self.init(p1.value, p2.value, .ninf) }
}
public extension Plane {
    init?(passing p1: Point, _ p2: Point, _ p3: Point) { self.init(p1.value, p2.value, p3.value, .ninf) }
    init?(passing p: Point, _ l: Line) { self.init(p.value, l.value) }
    init?(passing l: Line, _ p: Point) { self.init(p.value, l.value) }
}
public extension Circle {
    init?(passing p1: Point, _ p2: Point, _ p3: Point) { self.init(p1.value, p2.value, p3.value) }
}
public extension Sphere {
    init?(passing p1: Point, _ p2: Point, _ p3: Point, _ p4: Point) { self.init(p1.value, p2.value, p3.value, p4.value) }
    init?(passing p: Point, _ c: Circle) { self.init(p.value, c.value) }
    init?(passing c: Circle, p: Point) { self.init(c.value, p.value) }
}
