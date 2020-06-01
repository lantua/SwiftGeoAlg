//
//  Computations.swift
//  
//
//  Created by Natchanon Luangsomboon on 28/5/2563 BE.
//

extension Storage {
    @inlinable mutating
    func add<O>(_ other: O) where O: Storage {
        guard !(self is Empty) else { return }
        if Included.self != Empty.self {
            included.add(other.included)
        }
        if Excluded.self != Empty.self {
            excluded.add(other.excluded)
        }
    }

    @inlinable mutating
    func subtract<O>(_ other: O) where O: Storage {
        guard !(self is Empty) else { return }
        if Included.self != Empty.self {
            included.subtract(other.included)
        }
        if Excluded.self != Empty.self {
            excluded.subtract(other.excluded)
        }
    }
}

extension Storage {
    @inlinable mutating
    func add<L, R, BC, PF>(productOf lhs: L, _ rhs: R, bases: BC.Type, filter: PF.Type) where L: Storage, R: Storage, BC: BasisChain, PF: ProductFilter {
        _add(productOf: lhs, rhs, bc: BC.self, alt: False.self, flip: False.self, filter: PF.self)
    }

    @inlinable mutating
    func subtract<L, R, BC, PF>(productOf lhs: L, _ rhs: R, bases: BC.Type, filter: PF.Type) where L: Storage, R: Storage, BC: BasisChain, PF: ProductFilter {
        _add(productOf: lhs, rhs, bc: BC.self, alt: False.self, flip: True.self, filter: PF.self)
    }

    @inlinable mutating
    func _add<L, R, BC, Alt, Flp, PF>(productOf lhs: L, _ rhs: R, bc: BC.Type, alt: Alt.Type, flip: Flp.Type, filter: PF.Type) where L: Storage, R: Storage, BC: BasisChain, Alt: MetaBool, Flp: MetaBool, PF: ProductFilter {
        guard PF.self != FilterReject.self, !(self is Empty), !(lhs is Empty), !(rhs is Empty) else { return }

        // Toggle Alt if r.included
        // Toggle Flp if Alt && lhs.included
        // Toggle Flp *again* if lhs.included, rhs.included and NegativeBasis
        guard BC.self != EndBasisChain.self else {
            if Flp.self == True.self {
                scalar -= lhs.scalar * rhs.scalar
            } else {
                scalar += lhs.scalar * rhs.scalar
            }
            return
        }

        if Alt.self == True.self {
            if BC.Current.self == Positive.self {
                excluded._add(productOf: lhs.included, rhs.included, bc: BC.Tail.self, alt: Alt.Toggle.self, flip: Flp.Toggle.self, filter: PF.Both.self)
            } else if BC.Current.self == Negative.self {
                excluded._add(productOf: lhs.included, rhs.included, bc: BC.Tail.self, alt: Alt.Toggle.self, flip: Flp.self, filter: PF.Both.self)
            }
            included._add(productOf: lhs.included, rhs.excluded, bc: BC.Tail.self, alt: Alt.self, flip: Flp.Toggle.self, filter: PF.Left.self)
        } else {
            if BC.Current.self == Positive.self {
                excluded._add(productOf: lhs.included, rhs.included, bc: BC.Tail.self, alt: Alt.Toggle.self, flip: Flp.self, filter: PF.Both.self)
            } else if BC.Current.self == Negative.self {
                excluded._add(productOf: lhs.included, rhs.included, bc: BC.Tail.self, alt: Alt.Toggle.self, flip: Flp.Toggle.self, filter: PF.Both.self)
            }
            included._add(productOf: lhs.included, rhs.excluded, bc: BC.Tail.self, alt: Alt.self, flip: Flp.self, filter: PF.Left.self)
        }

        included._add(productOf: lhs.excluded, rhs.included, bc: BC.Tail.self, alt: Alt.Toggle.self, flip: Flp.self, filter: PF.Right.self)
        excluded._add(productOf: lhs.excluded, rhs.excluded, bc: BC.Tail.self, alt: Alt.self, flip: Flp.self, filter: PF.self)
    }
}
