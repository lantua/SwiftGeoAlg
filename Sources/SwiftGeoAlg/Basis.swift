//
//  Basis.swift
//  
//
//  Created by Natchanon Luangsomboon on 1/6/2563 BE.
//

/**
 * - Note: Conformer can use `PositiveBasis`, `NegativeBasis`, or `ZeroBasis`, to help facilitate conformance.
 * - Remark:
 *     Most underlying structures treat the `Basis` chain with the same positive/negative/zero order as the same type.
 *     You can arrange bases to have similar tail pattern (e.g. `PPNNZEnd` and `NNZEnd`) to increase the chance of code reuse.
 */
public protocol Basis {
    /**
     * Next basis in the basis chain.
     * - Requires: The `Next` chain eventually reach `NoBasis`.
     */
    associatedtype Next: Basis

    /**
     * The sign of this basis.
     * - Requires: One of `Positive`, `Negative`, and `Zero`.
     */
    associatedtype Sign: BasisSign

    /// - Attention: Internal use, do not override this.
    associatedtype Chain: BasisChain = _Chain<Self>
}
public typealias _Chain<B: Basis> = MidBasisChain<B.Sign, B.Next.Chain>
public protocol PositiveBasis: Basis where Sign == Positive { }
public protocol NegativeBasis: Basis where Sign == Negative { }
public protocol ZeroBasis: Basis where Sign == Zero { }

public protocol BasisSign { }
public enum Positive: BasisSign { }
public enum Negative: BasisSign { }
public enum Zero: BasisSign { }

public enum NoBasis: ZeroBasis {
    public typealias Next = Self
    public typealias Chain = EndBasisChain
}

public protocol BasisChain {
    associatedtype Sign: BasisSign
    associatedtype Tail: BasisChain
}
public enum EndBasisChain: BasisChain {
    public typealias Sign = Zero
    public typealias Tail = Self
}
public enum MidBasisChain<Sign: BasisSign, Tail: BasisChain>: BasisChain { }
