//
//  Multipliers.swift
//  
//
//  Created by Natchanon Luangsomboon on 1/6/2563 BE.
//

@usableFromInline protocol PrimaryMultiplier: Multiplier {
    static func multiply<L, R, O, B, Inv, Flp>(included lhs: L, included rhs: R, into out: inout O, bases: B.Type, involute: Inv.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain, Inv: MetaBool, Flp: MetaBool
    static func multiply<L, R, O, B, Inv, Flp>(included lhs: L, excluded rhs: R, into out: inout O, bases: B.Type, involute: Inv.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain, Inv: MetaBool, Flp: MetaBool
    static func multiply<L, R, O, B, Inv, Flp>(excluded lhs: L, included rhs: R, into out: inout O, bases: B.Type, involute: Inv.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain, Inv: MetaBool, Flp: MetaBool
}

public enum OuterProduct: PrimaryMultiplier {
    @inlinable static func multiply<L, R, O, B, Inv, Flp>(included lhs: L, included rhs: R, into out: inout O, bases: B.Type, involute: Inv.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain, Inv: MetaBool, Flp: MetaBool { }
}
public enum LeftInnerProduct: PrimaryMultiplier {
    @inlinable static func multiply<L, R, O, B, Inv, Flp>(included lhs: L, excluded rhs: R, into out: inout O, bases: B.Type, involute: Inv.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain, Inv: MetaBool, Flp: MetaBool { }
}
public enum RightInnerProduct: PrimaryMultiplier {
    @inlinable static func multiply<L, R, O, B, Inv, Flp>(excluded lhs: L, included rhs: R, into out: inout O, bases: B.Type, involute: Inv.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain, Inv: MetaBool, Flp: MetaBool { }
}
public enum FatDotProduct: PrimaryMultiplier {
    @inlinable static func multiply<L, R, O, B, Inv, Flp>(included lhs: L, excluded rhs: R, into out: inout O, bases: B.Type, involute: Inv.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain, Inv: MetaBool, Flp: MetaBool {
        RightInnerProduct.multiply(included: lhs, excluded: rhs, into: &out, bases: B.self, involute: Inv.self, flip: Flp.self)
    }
    @inlinable static func multiply<L, R, O, B, Inv, Flp>(excluded lhs: L, included rhs: R, into out: inout O, bases: B.Type, involute: Inv.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain, Inv: MetaBool, Flp: MetaBool {
        LeftInnerProduct.multiply(excluded: lhs, included: rhs, into: &out, bases: B.self, involute: Inv.self, flip: Flp.self)
    }
}

public enum ScalarProduct: PrimaryMultiplier {
    @inlinable static func multiply<L, R, O, B, Inv, Flp>(included lhs: L, included rhs: R, into out: inout O, bases: B.Type, involute: Inv.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain, Inv: MetaBool, Flp: MetaBool { }
    @inlinable static func multiply<L, R, O, B, Inv, Flp>(included lhs: L, excluded rhs: R, into out: inout O, bases: B.Type, involute: Inv.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain, Inv: MetaBool, Flp: MetaBool { }
    @inlinable static func multiply<L, R, O, B, Inv, Flp>(excluded lhs: L, included rhs: R, into out: inout O, bases: B.Type, involute: Inv.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain, Inv: MetaBool, Flp: MetaBool { }
}

extension PrimaryMultiplier {
    @inlinable public static func add<L, R, O, B>(productOf lhs: L, _ rhs: R, to out: inout O, bases: B.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain {
        multiply(lhs, rhs, into: &out, bases: B.self, involute: False.self, flip: False.self)
    }
    @inlinable public static func subtract<L, R, O, B>(productOf lhs: L, _ rhs: R, from out: inout O, bases: B.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain {
        multiply(lhs, rhs, into: &out, bases: B.self, involute: False.self, flip: True.self)
    }

    // Toggle Inv if r.included
    // Toggle Flp if Inv && lhs.included
    // Toggle Flp *again* if lhs.included, rhs.included and NegativeBasis

    @inlinable static func multiply<L, R, O, B, Inv, Flp>(_ lhs: L, _ rhs: R, into out: inout O, bases: B.Type, involute: Inv.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain, Inv: MetaBool, Flp: MetaBool {
        guard !(out is Empty), !(lhs is Empty), !(rhs is Empty) else { return }

        guard B.self != EndBasisChain.self else {
            if Flp.self == True.self {
                out.scalar -= lhs.scalar * rhs.scalar
            } else {
                out.scalar += lhs.scalar * rhs.scalar
            }
            return
        }

        multiply(included: lhs, included: rhs, into: &out, bases: B.self, involute: Inv.self, flip: Flp.self)
        multiply(included: lhs, excluded: rhs, into: &out, bases: B.self, involute: Inv.self, flip: Flp.self)
        multiply(excluded: lhs, included: rhs, into: &out, bases: B.self, involute: Inv.self, flip: Flp.self)
        multiply(lhs.excluded, rhs.excluded, into: &out.excluded, bases: B.Tail.self, involute: Inv.self, flip: Flp.self)
    }
    @inlinable static func multiply<L, R, O, B, Inv, Flp>(included lhs: L, included rhs: R, into out: inout O, bases: B.Type, involute: Inv.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain, Inv: MetaBool, Flp: MetaBool {
        if Inv.self == True.self {
            if B.Sign.self == Positive.self {
                multiply(lhs.included, rhs.included, into: &out.excluded, bases: B.Tail.self, involute: Inv.Toggle.self, flip: Flp.Toggle.self)
            } else if B.Sign.self == Negative.self {
                multiply(lhs.included, rhs.included, into: &out.excluded, bases: B.Tail.self, involute: Inv.Toggle.self, flip: Flp.self)
            }
        } else {
            if B.Sign.self == Positive.self {
                multiply(lhs.included, rhs.included, into: &out.excluded, bases: B.Tail.self, involute: Inv.Toggle.self, flip: Flp.self)
            } else if B.Sign.self == Negative.self {
                multiply(lhs.included, rhs.included, into: &out.excluded, bases: B.Tail.self, involute: Inv.Toggle.self, flip: Flp.Toggle.self)
            }
        }
    }
    @inlinable static func multiply<L, R, O, B, Inv, Flp>(included lhs: L, excluded rhs: R, into out: inout O, bases: B.Type, involute: Inv.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain, Inv: MetaBool, Flp: MetaBool {
        if Inv.self == True.self {
            multiply(lhs.included, rhs.excluded, into: &out.included, bases: B.Tail.self, involute: Inv.self, flip: Flp.Toggle.self)
        } else {
            multiply(lhs.included, rhs.excluded, into: &out.included, bases: B.Tail.self, involute: Inv.self, flip: Flp.self)
        }
    }
    @inlinable static func multiply<L, R, O, B, Inv, Flp>(excluded lhs: L, included rhs: R, into out: inout O, bases: B.Type, involute: Inv.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain, Inv: MetaBool, Flp: MetaBool {
        multiply(lhs.excluded, rhs.included, into: &out.included, bases: B.Tail.self, involute: Inv.Toggle.self, flip: Flp.self)
    }
}
