//
//  Computations.swift
//  
//
//  Created by Natchanon Luangsomboon on 28/5/2563 BE.
//


public protocol ComputableStorage: Storage {
    mutating func add<O>(_ other: O) where O: Storage
    mutating func subtract<O>(_ other: O) where O: Storage

    @inlinable
    mutating func _add<L, R, BC, Alt, Flp, PF>(productOf lhs: L, _ rhs: R, bc: BC.Type, alt: Alt.Type, flip: Flp.Type, filter: PF.Type) where L: Storage, R: Storage, BC: BasisChain, Alt: MetaBool, Flp: MetaBool, PF: ProductFilter
}

public extension ComputableStorage {
    @inlinable
    mutating func add<L, R, BC, PF>(productOf lhs: L, _ rhs: R, bases: BC.Type, filter: PF.Type) where L: Storage, R: Storage, BC: BasisChain, PF: ProductFilter {
        _add(productOf: lhs, rhs, bc: BC.self, alt: MetaFalse.self, flip: MetaFalse.self, filter: PF.self)
    }

    mutating func subtract<L, R, BC, PF>(productOf lhs: L, _ rhs: R, bases: BC.Type, filter: PF.Type) where L: Storage, R: Storage, BC: BasisChain, PF: ProductFilter {
        _add(productOf: lhs, rhs, bc: BC.self, alt: MetaFalse.self, flip: MetaTrue.self, filter: PF.self)
    }
}

public extension ComputableStorage where Included: ComputableStorage, Excluded: ComputableStorage {
    @inlinable
    mutating func _add<L, R, BC, Alt, Flp, PF>(productOf lhs: L, _ rhs: R, bc: BC.Type, alt: Alt.Type, flip: Flp.Type, filter: PF.Type) where L : Storage, R : Storage, BC : BasisChain, Alt : MetaBool, Flp : MetaBool, PF : ProductFilter {
        guard !(lhs is Empty), !(rhs is Empty), PF.self != FilterReject.self else { return }

        // Toggle Alt if r.included
        // Toggle Flp if Alt && lhs.included
        // Toggle Flp *again* if lhs.included, rhs.included and NegativeBasis
        if BC.self != EndBasisChain.self {
            if Alt.value {
                if BC.Current.self == PositiveBasis.self {
                    excluded._add(productOf: lhs.included, rhs.included, bc: BC.Next.self, alt: Alt.Toggle.self, flip: Flp.Toggle.self, filter: PF.Both.self)
                } else if BC.Current.self == NegativeBasis.self {
                    excluded._add(productOf: lhs.included, rhs.included, bc: BC.Next.self, alt: Alt.Toggle.self, flip: Flp.self, filter: PF.Both.self)
                }
                included._add(productOf: lhs.included, rhs.excluded, bc: BC.Next.self, alt: Alt.self, flip: Flp.Toggle.self, filter: PF.Left.self)
            } else {
                if BC.Current.self == PositiveBasis.self {
                    excluded._add(productOf: lhs.included, rhs.included, bc: BC.Next.self, alt: Alt.Toggle.self, flip: Flp.self, filter: PF.Both.self)
                } else if BC.Current.self == NegativeBasis.self {
                    excluded._add(productOf: lhs.included, rhs.included, bc: BC.Next.self, alt: Alt.Toggle.self, flip: Flp.Toggle.self, filter: PF.Both.self)
                }
                included._add(productOf: lhs.included, rhs.excluded, bc: BC.Next.self, alt: Alt.self, flip: Flp.self, filter: PF.Left.self)
            }

            included._add(productOf: lhs.excluded, rhs.included, bc: BC.Next.self, alt: Alt.Toggle.self, flip: Flp.self, filter: PF.Right.self)
            excluded._add(productOf: lhs.excluded, rhs.excluded, bc: BC.Next.self, alt: Alt.self, flip: Flp.self, filter: PF.self)
        } else if Flp.value {
            scalar -= lhs.scalar * rhs.scalar
        } else {
            scalar += lhs.scalar * rhs.scalar
        }
    }
}

extension Empty: ComputableStorage {
    public func add<O>(_ other: O) where O: Storage { }
    public func subtract<O>(_ other: O) where O: Storage { }

    @inlinable
    public func _add<L, R, BC, Alt, Flp, PF>(productOf lhs: L, _ rhs: R, bc: BC.Type, alt: Alt.Type, flip: Flp.Type, filter: PF.Type) where L: Storage, R: Storage, BC: BasisChain, Alt: MetaBool, Flp: MetaBool, PF: ProductFilter { }
}

extension Scalar: ComputableStorage {
    public mutating func add<O>(_ other: O) where O : Storage { scalar += other.scalar }
    public mutating func subtract<O>(_ other: O) where O : Storage { scalar -= other.scalar }
}

extension Mixed: ComputableStorage where Included: ComputableStorage, Excluded: ComputableStorage {
    public mutating func add<O>(_ other: O) where O: Storage {
        included.add(other.included)
        excluded.add(other.excluded)
    }
    public mutating func subtract<O>(_ other: O) where O: Storage {
        included.subtract(other.included)
        excluded.subtract(other.excluded)
    }
}
