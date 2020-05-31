//
//  Utilities.swift
//  
//
//  Created by Natchanon Luangsomboon on 30/5/2563 BE.
//

import Foundation

public protocol ByteZeroable: Storage { }
public extension ByteZeroable {
    mutating func reset() { _ = withUnsafeMutableBytes(of: &self) { memset($0.baseAddress, 0, $0.count) } }
}

extension Empty: ByteZeroable { }
extension Scalar: ByteZeroable { }
extension Mixed: ByteZeroable where Included: ByteZeroable, Excluded: ByteZeroable { }
