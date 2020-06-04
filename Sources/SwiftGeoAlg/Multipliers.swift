//
//  Multipliers.swift
//  
//
//  Created by Natchanon Luangsomboon on 1/6/2563 BE.
//

@usableFromInline protocol PrimaryMultiplier: Multiplier {
    static func multiply<L, R, O, B>(included lhs: L, included rhs: R, into out: inout O, bases: B.Type, state: PrimaryMultiplierState) where L: Storage, R: Storage, O: Storage, B: BasisChain
    static func multiply<L, R, O, B>(included lhs: L, excluded rhs: R, into out: inout O, bases: B.Type, state: PrimaryMultiplierState) where L: Storage, R: Storage, O: Storage, B: BasisChain
    static func multiply<L, R, O, B>(excluded lhs: L, included rhs: R, into out: inout O, bases: B.Type, state: PrimaryMultiplierState) where L: Storage, R: Storage, O: Storage, B: BasisChain
}

@usableFromInline enum PrimaryMultiplierState {
    case add, subtract, involuteAdd, involuteSubtract

    @inlinable var flip: Self {
        switch self {
        case .add: return .subtract
        case .subtract: return .add
        case .involuteAdd: return .involuteSubtract
        case .involuteSubtract: return .involuteAdd
        }
    }
    @inlinable var cont: Self {
        switch self {
        case .add: return .add
        case .subtract: return .subtract
        case .involuteAdd: return .involuteSubtract
        case .involuteSubtract: return .involuteAdd
        }
    }
    @inlinable var inv: Self {
        switch self {
        case .add: return .involuteAdd
        case .subtract: return .involuteSubtract
        case .involuteAdd: return .add
        case .involuteSubtract: return .subtract
        }
    }
}

public enum OuterProduct: PrimaryMultiplier {
    @inlinable static func multiply<L, R, O, B>(included lhs: L, included rhs: R, into out: inout O, bases: B.Type, state: PrimaryMultiplierState) where L : Storage, R : Storage, O : Storage, B : BasisChain { }
}
public enum LeftInnerProduct: PrimaryMultiplier {
    @inlinable static func multiply<L, R, O, B>(included lhs: L, excluded rhs: R, into out: inout O, bases: B.Type, state: PrimaryMultiplierState) where L : Storage, R : Storage, O : Storage, B : BasisChain { }
}
public enum RightInnerProduct: PrimaryMultiplier {
    @inlinable static func multiply<L, R, O, B>(excluded lhs: L, included rhs: R, into out: inout O, bases: B.Type, state: PrimaryMultiplierState) where L : Storage, R : Storage, O : Storage, B : BasisChain { }
}
public enum FatDotProduct: PrimaryMultiplier {
    @inlinable static func multiply<L, R, O, B>(included lhs: L, excluded rhs: R, into out: inout O, bases: B.Type, state: PrimaryMultiplierState) where L : Storage, R : Storage, O : Storage, B : BasisChain {
        RightInnerProduct.multiply(included: lhs, excluded: rhs, into: &out, bases: B.self, state: state)
    }
    @inlinable static func multiply<L, R, O, B>(excluded lhs: L, included rhs: R, into out: inout O, bases: B.Type, state: PrimaryMultiplierState) where L : Storage, R : Storage, O : Storage, B : BasisChain {
        LeftInnerProduct.multiply(excluded: lhs, included: rhs, into: &out, bases: B.self, state: state)
    }
}

public enum ScalarProduct: PrimaryMultiplier {
    @inlinable static func multiply<L, R, O, B>(included lhs: L, included rhs: R, into out: inout O, bases: B.Type, state: PrimaryMultiplierState) where L : Storage, R : Storage, O : Storage, B : BasisChain { }
    @inlinable static func multiply<L, R, O, B>(included lhs: L, excluded rhs: R, into out: inout O, bases: B.Type, state: PrimaryMultiplierState) where L : Storage, R : Storage, O : Storage, B : BasisChain { }
    @inlinable static func multiply<L, R, O, B>(excluded lhs: L, included rhs: R, into out: inout O, bases: B.Type, state: PrimaryMultiplierState) where L : Storage, R : Storage, O : Storage, B : BasisChain { }
}

extension PrimaryMultiplier {
    @inlinable public static func add<L, R, O, B>(productOf lhs: L, _ rhs: R, to out: inout O, bases: B.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain {
        multiply(lhs, rhs, into: &out, bases: B.self, state: .add)
    }
    @inlinable public static func subtract<L, R, O, B>(productOf lhs: L, _ rhs: R, from out: inout O, bases: B.Type) where L: Storage, R: Storage, O: Storage, B: BasisChain {
        multiply(lhs, rhs, into: &out, bases: B.self, state: .subtract)
    }

    // Toggle Inv if r.included
    // Toggle Flp if Inv && lhs.included
    // Toggle Flp *again* if lhs.included, rhs.included and NegativeBasis

    @inlinable static func multiply<L, R, O, B>(_ lhs: L, _ rhs: R, into out: inout O, bases: B.Type, state: PrimaryMultiplierState) where L: Storage, R: Storage, O: Storage, B: BasisChain {
        // Unnecessary on optimized build, but would help on debug build.
        guard !(out is Empty), !(lhs is Empty), !(rhs is Empty) else { return }

        guard B.self != EndBasisChain.self else {
            if O.ScalarType.self != Never.self, L.ScalarType.self != Never.self, R.ScalarType.self != Never.self {
                switch state {
                case .add, .involuteAdd: out.scalar.value += lhs.scalar.value * rhs.scalar.value
                case .subtract, .involuteSubtract: out.scalar.value -= lhs.scalar.value * rhs.scalar.value
                }
            }
            return
        }

        multiply(included: lhs, included: rhs, into: &out, bases: B.self, state: state)
        multiply(included: lhs, excluded: rhs, into: &out, bases: B.self, state: state)
        multiply(excluded: lhs, included: rhs, into: &out, bases: B.self, state: state)
        multiply(lhs.excluded, rhs.excluded, into: &out.excluded, bases: B.Tail.self, state: state)
    }
    @inlinable static func multiply<L, R, O, B>(included lhs: L, included rhs: R, into out: inout O, bases: B.Type, state: PrimaryMultiplierState) where L: Storage, R: Storage, O: Storage, B: BasisChain {
        if B.Sign.self == Positive.self {
            multiply(lhs.included, rhs.included, into: &out.excluded, bases: B.Tail.self, state: state.cont.inv)
        } else if B.Sign.self == Negative.self {
            multiply(lhs.included, rhs.included, into: &out.excluded, bases: B.Tail.self, state: state.cont.inv.flip)
        }
    }
    @inlinable static func multiply<L, R, O, B>(included lhs: L, excluded rhs: R, into out: inout O, bases: B.Type, state: PrimaryMultiplierState) where L: Storage, R: Storage, O: Storage, B: BasisChain {
        multiply(lhs.included, rhs.excluded, into: &out.included, bases: B.Tail.self, state: state.cont)
    }
    @inlinable static func multiply<L, R, O, B>(excluded lhs: L, included rhs: R, into out: inout O, bases: B.Type, state: PrimaryMultiplierState) where L: Storage, R: Storage, O: Storage, B: BasisChain {
        multiply(lhs.excluded, rhs.included, into: &out.included, bases: B.Tail.self, state: state.inv)
    }
}
