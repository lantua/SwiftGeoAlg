//
//  Utilities.swift
//  
//
//  Created by Natchanon Luangsomboon on 30/5/2563 BE.
//

import Foundation

// MARK: Byte zeroable

public protocol ByteZeroable: Storage { }
public extension ByteZeroable {
    mutating func reset() { _ = withUnsafeMutableBytes(of: &self) { memset($0.baseAddress, 0, $0.count) } }
}

extension Empty: ByteZeroable { }
extension Scalar: ByteZeroable { }
extension Mixed: ByteZeroable where Included: ByteZeroable, Excluded: ByteZeroable { }

// MARK: ExpressibleByFloatLiteral

extension Scalar: ExpressibleByFloatLiteral {
    @inlinable public init(floatLiteral value: ScalarValue.FloatLiteralType) { scalar = .init(floatLiteral: value) }
}
extension Mixed where Excluded: ExpressibleByFloatLiteral {
    @inlinable public init(floatLiteral value: Excluded.FloatLiteralType) { excluded = .init(floatLiteral: value) }
}
