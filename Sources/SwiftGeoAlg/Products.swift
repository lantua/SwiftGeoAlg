//
//  Multipliers.swift
//  
//
//  Created by Natchanon Luangsomboon on 1/6/2563 BE.
//

@usableFromInline protocol Product: Accumulable {
    associatedtype L: Storage
    associatedtype R: Storage

    init(_ lhs: L, _ rhs: R)
    var lhs: L { get }
    var rhs: R { get }

    func add<O>(into out: inout O, state: ProductState) where O: Storage
    associatedtype II: Product where II.L == L.Included, II.R == R.Included, II.Chain == Chain.Tail
    associatedtype IE: Product where IE.L == L.Included, IE.R == R.Excluded, IE.Chain == Chain.Tail
    associatedtype EI: Product where EI.L == L.Excluded, EI.R == R.Included, EI.Chain == Chain.Tail
    associatedtype EE: Product where EE.L == L.Excluded, EE.R == R.Excluded, EE.Chain == Chain.Tail
}
@usableFromInline struct ProductNone<L: Storage, R: Storage, Chain: BasisChain>: Product {
    @usableFromInline var lhs: L, rhs: R
    @inlinable init(_ lhs: L, _ rhs: R) {
        self.lhs = lhs
        self.rhs = rhs
    }

    @inlinable func add<O>(into out: inout O, state: ProductState) where O : Storage { }
    @usableFromInline typealias II = ProductNone<L.Included, R.Included, Chain.Tail>
    @usableFromInline typealias IE = ProductNone<L.Included, R.Excluded, Chain.Tail>
    @usableFromInline typealias EI = ProductNone<L.Excluded, R.Included, Chain.Tail>
    @usableFromInline typealias EE = ProductNone<L.Excluded, R.Excluded, Chain.Tail>
}

public struct OuterProduct<L: Storage, R: Storage, Chain: BasisChain>: Product {
    @usableFromInline var lhs: L, rhs: R
    @inlinable init(_ lhs: L, _ rhs: R) {
        self.lhs = lhs
        self.rhs = rhs
    }

    @usableFromInline typealias II = ProductNone<L.Included, R.Included, Chain.Tail>
    @usableFromInline typealias IE = OuterProduct<L.Included, R.Excluded, Chain.Tail>
    @usableFromInline typealias EI = OuterProduct<L.Excluded, R.Included, Chain.Tail>
    @usableFromInline typealias EE = OuterProduct<L.Excluded, R.Excluded, Chain.Tail>
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

extension Product {
    @inlinable public static func +=<O: Storage>(lhs: inout Vector<Chain, O>, rhs: Self) {
        rhs.add(into: &lhs.storage, state: .add)
    }
    @inlinable public static func -=<O: Storage>(lhs: inout Vector<Chain, O>, rhs: Self) {
        rhs.add(into: &lhs.storage, state: .subtract)
    }

    @inlinable func add<O>(into out: inout O, state: ProductState) where O: Storage {
        // Unnecessary, but would help on debug build.
        guard !(out is Empty), !(lhs is Empty), !(rhs is Empty) else { return }

        guard Chain.self != EndBasisChain.self else {
            if O.ScalarType.self != Never.self, L.ScalarType.self != Never.self, R.ScalarType.self != Never.self {
                switch state {
                case .add, .involuteAdd: out.scalar.value += lhs.scalar.value * rhs.scalar.value
                case .subtract, .involuteSubtract: out.scalar.value -= lhs.scalar.value * rhs.scalar.value
                }
            }
            return
        }

        if Chain.Sign.self == Positive.self {
            II(lhs.included, rhs.included).add(into: &out.excluded, state: state.cont.inv)
        } else if Chain.Sign.self == Negative.self {
            II(lhs.included, rhs.included).add(into: &out.excluded, state: state.cont.inv.flip)
        }
        IE(lhs.included, rhs.excluded).add(into: &out.included, state: state.cont)
        EI(lhs.excluded, rhs.included).add(into: &out.included, state: state.inv)
        EE(lhs.excluded, rhs.excluded).add(into: &out.excluded, state: state)
    }
}
