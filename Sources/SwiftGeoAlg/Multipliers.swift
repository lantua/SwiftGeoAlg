//
//  Multipliers.swift
//  
//
//  Created by Natchanon Luangsomboon on 1/6/2563 BE.
//

@usableFromInline protocol PrimaryMultiplier: Multiplier {
    static func multiply<L, R, O, BC, Alt, Flp>(included lhs: L, included rhs: R, into out: inout O, bases: BC.Type, alt: Alt.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, BC: BasisChain, Alt: MetaBool, Flp: MetaBool
    static func multiply<L, R, O, BC, Alt, Flp>(included lhs: L, excluded rhs: R, into out: inout O, bases: BC.Type, alt: Alt.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, BC: BasisChain, Alt: MetaBool, Flp: MetaBool
    static func multiply<L, R, O, BC, Alt, Flp>(excluded lhs: L, included rhs: R, into out: inout O, bases: BC.Type, alt: Alt.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, BC: BasisChain, Alt: MetaBool, Flp: MetaBool
}

public enum OuterProduct: PrimaryMultiplier {
    @inlinable static func multiply<L, R, O, BC, Alt, Flp>(included lhs: L, included rhs: R, into out: inout O, bases: BC.Type, alt: Alt.Type, flip: Flp.Type) where L : Storage, R : Storage, O : Storage, BC : BasisChain, Alt : MetaBool, Flp : MetaBool { }
}
public enum LeftInnerProduct: PrimaryMultiplier {
    @inlinable static func multiply<L, R, O, BC, Alt, Flp>(included lhs: L, excluded rhs: R, into out: inout O, bases: BC.Type, alt: Alt.Type, flip: Flp.Type) where L : Storage, R : Storage, O : Storage, BC : BasisChain, Alt : MetaBool, Flp : MetaBool { }
}
public enum RightInnerProduct: PrimaryMultiplier {
    @inlinable static func multiply<L, R, O, BC, Alt, Flp>(excluded lhs: L, included rhs: R, into out: inout O, bases: BC.Type, alt: Alt.Type, flip: Flp.Type) where L : Storage, R : Storage, O : Storage, BC : BasisChain, Alt : MetaBool, Flp : MetaBool { }
}
public enum FatDotProduct: PrimaryMultiplier {
    @inlinable static func multiply<L, R, O, BC, Alt, Flp>(included lhs: L, excluded rhs: R, into out: inout O, bases: BC.Type, alt: Alt.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, BC: BasisChain, Alt: MetaBool, Flp: MetaBool {
        RightInnerProduct.multiply(included: lhs, excluded: rhs, into: &out, bases: BC.self, alt: Alt.self, flip: Flp.self)
    }
    @inlinable static func multiply<L, R, O, BC, Alt, Flp>(excluded lhs: L, included rhs: R, into out: inout O, bases: BC.Type, alt: Alt.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, BC: BasisChain, Alt: MetaBool, Flp: MetaBool {
        LeftInnerProduct.multiply(excluded: lhs, included: rhs, into: &out, bases: BC.self, alt: Alt.self, flip: Flp.self)
    }
}

public enum ScalarProduct: PrimaryMultiplier {
    @inlinable static func multiply<L, R, O, BC, Alt, Flp>(included lhs: L, excluded rhs: R, into out: inout O, bases: BC.Type, alt: Alt.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, BC: BasisChain, Alt: MetaBool, Flp: MetaBool { }
    @inlinable static func multiply<L, R, O, BC, Alt, Flp>(excluded lhs: L, included rhs: R, into out: inout O, bases: BC.Type, alt: Alt.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, BC: BasisChain, Alt: MetaBool, Flp: MetaBool { }
    @inlinable static func multiply<L, R, O, BC, Alt, Flp>(excluded lhs: L, excluded rhs: R, into out: inout O, bases: BC.Type, alt: Alt.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, BC: BasisChain, Alt: MetaBool, Flp: MetaBool { }
}

extension PrimaryMultiplier {
    @inlinable public static func add<L, R, O, BC>(productOf lhs: L, _ rhs: R, to out: inout O, bases: BC.Type) where L: Storage, R: Storage, O: Storage, BC: BasisChain {
        multiply(lhs, rhs, into: &out, bases: BC.self, alt: False.self, flip: False.self)
    }
    @inlinable public static func subtract<L, R, O, BC>(productOf lhs: L, _ rhs: R, from out: inout O, bases: BC.Type) where L: Storage, R: Storage, O: Storage, BC: BasisChain {
        multiply(lhs, rhs, into: &out, bases: BC.self, alt: False.self, flip: True.self)
    }

    // Toggle Alt if r.included
    // Toggle Flp if Alt && lhs.included
    // Toggle Flp *again* if lhs.included, rhs.included and NegativeBasis

    @inlinable static func multiply<L, R, O, BC, Alt, Flp>(_ lhs: L, _ rhs: R, into out: inout O, bases: BC.Type, alt: Alt.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, BC: BasisChain, Alt: MetaBool, Flp: MetaBool {
        guard !(out is Empty), !(lhs is Empty), !(rhs is Empty) else { return }

        guard BC.self != EndBasisChain.self else {
            if Flp.self == True.self {
                out.scalar -= lhs.scalar * rhs.scalar
            } else {
                out.scalar += lhs.scalar * rhs.scalar
            }
            return
        }

        multiply(included: lhs, included: rhs, into: &out, bases: BC.self, alt: Alt.self, flip: Flp.self)
        multiply(included: lhs, excluded: rhs, into: &out, bases: BC.self, alt: Alt.self, flip: Flp.self)
        multiply(excluded: lhs, included: rhs, into: &out, bases: BC.self, alt: Alt.self, flip: Flp.self)
        multiply(lhs.excluded, rhs.excluded, into: &out.excluded, bases: BC.Tail.self, alt: Alt.self, flip: Flp.self)
    }
    @inlinable static func multiply<L, R, O, BC, Alt, Flp>(included lhs: L, included rhs: R, into out: inout O, bases: BC.Type, alt: Alt.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, BC: BasisChain, Alt: MetaBool, Flp: MetaBool {
        if Alt.self == True.self {
            if BC.Sign.self == Positive.self {
                multiply(lhs.included, rhs.included, into: &out.excluded, bases: BC.Tail.self, alt: Alt.Toggle.self, flip: Flp.Toggle.self)
            } else if BC.Sign.self == Negative.self {
                multiply(lhs.included, rhs.included, into: &out.excluded, bases: BC.Tail.self, alt: Alt.Toggle.self, flip: Flp.self)
            }
        } else {
            if BC.Sign.self == Positive.self {
                multiply(lhs.included, rhs.included, into: &out.excluded, bases: BC.Tail.self, alt: Alt.Toggle.self, flip: Flp.self)
            } else if BC.Sign.self == Negative.self {
                multiply(lhs.included, rhs.included, into: &out.excluded, bases: BC.Tail.self, alt: Alt.Toggle.self, flip: Flp.Toggle.self)
            }
        }
    }
    @inlinable static func multiply<L, R, O, BC, Alt, Flp>(included lhs: L, excluded rhs: R, into out: inout O, bases: BC.Type, alt: Alt.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, BC: BasisChain, Alt: MetaBool, Flp: MetaBool {
        if Alt.self == True.self {
            multiply(lhs.included, rhs.excluded, into: &out.included, bases: BC.Tail.self, alt: Alt.self, flip: Flp.Toggle.self)
        } else {
            multiply(lhs.included, rhs.excluded, into: &out.included, bases: BC.Tail.self, alt: Alt.self, flip: Flp.self)
        }
    }
    @inlinable static func multiply<L, R, O, BC, Alt, Flp>(excluded lhs: L, included rhs: R, into out: inout O, bases: BC.Type, alt: Alt.Type, flip: Flp.Type) where L: Storage, R: Storage, O: Storage, BC: BasisChain, Alt: MetaBool, Flp: MetaBool {
        multiply(lhs.excluded, rhs.included, into: &out.included, bases: BC.Tail.self, alt: Alt.Toggle.self, flip: Flp.self)
    }
}
