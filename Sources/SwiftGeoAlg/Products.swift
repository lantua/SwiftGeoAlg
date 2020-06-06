//
//  Multipliers.swift
//  
//
//  Created by Natchanon Luangsomboon on 1/6/2563 BE.
//

@usableFromInline protocol Product: _Accumulable {
    associatedtype L: VectorProtocol
    associatedtype R: VectorProtocol

    var lhs: L { get }
    var rhs: R { get }

    func addII<O: Storage>(into out: inout O, state: ProductState)
    func addIE<O: Storage>(into out: inout O, state: ProductState)
    func addEI<O: Storage>(into out: inout O, state: ProductState)
    func addEE<O: Storage>(into out: inout O, state: ProductState)
}
extension Product {
    @inlinable func addII<O: Storage>(into out: inout O, state: ProductState) { }
    @inlinable func addIE<O: Storage>(into out: inout O, state: ProductState) { }
    @inlinable func addEI<O: Storage>(into out: inout O, state: ProductState) { }
    @inlinable func addEE<O: Storage>(into out: inout O, state: ProductState) { }
}

public struct OuterProduct<L: VectorProtocol, R: VectorProtocol>: Product where L.Bases == R.Bases {
    public typealias Bases = L.Bases

    @usableFromInline var lhs: L, rhs: R
    @inlinable init(_ lhs: L, _ rhs: R) {
        self.lhs = lhs
        self.rhs = rhs
    }

    @inlinable func addIE<O: Storage>(into out: inout O, state: ProductState) {
        OuterProduct<L.Included, R.Excluded>(lhs.included, rhs.excluded).add(into: &out.included, state: state)
    }
    @inlinable func addEI<O: Storage>(into out: inout O, state: ProductState) {
        OuterProduct<L.Excluded, R.Included>(lhs.excluded, rhs.included).add(into: &out.included, state: state)
    }
    @inlinable func addEE<O: Storage>(into out: inout O, state: ProductState) {
        OuterProduct<L.Excluded, R.Excluded>(lhs.excluded, rhs.excluded).add(into: &out.excluded, state: state)
    }
}

extension Product {
    @inlinable public func add<O: Storage>(to out: inout O) { add(into: &out, state: .add) }
    @inlinable public func subtract<O: Storage>(from out: inout O) { add(into: &out, state: .subtract) }

    @inlinable func add<O: Storage>(into out: inout O, state: ProductState) {
        // Unnecessary, but would help on debug build.
        guard !(out is Empty) else { return }

        guard Bases.self != EndBasisChain.self else {
            guard O.ScalarType.self != Never.self, L.ScalarType.self != Never.self, R.ScalarType.self != Never.self else { return
            }

            switch state {
            case .add, .involuteAdd: out.scalar.value += lhs.scalar.value * rhs.scalar.value
            case .subtract, .involuteSubtract: out.scalar.value -= lhs.scalar.value * rhs.scalar.value
            }
            return
        }

        if Bases.Sign.self == Positive.self {
            addII(into: &out, state: state.cont.inv)
        } else if Bases.Sign.self == Negative.self {
            addII(into: &out, state: state.cont.inv.flip)
        }
        addIE(into: &out, state: state.cont)
        addEI(into: &out, state: state.inv)
        addEE(into: &out, state: state)
    }
}

@usableFromInline enum ProductState {
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
