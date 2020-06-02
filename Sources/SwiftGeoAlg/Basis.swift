//
//  Basis.swift
//  
//
//  Created by Natchanon Luangsomboon on 1/6/2563 BE.
//

/**
 * - Requires: The `Next` chain eventually reach `NoBasis`.
 * - Note: Conformer can use `PositiveBasis`, `NegativeBasis`, or `ZeroBasis`, to help facilitate conformance.
 * - Remark:
 *     Most underlying structures treat the `Basis` chain with the same positive/negative/zero order as the same type.
 *     You can arrange bases to have similar tail pattern (e.g. `PPNNZEnd` and `NNZEnd`) to increase the chance of code reuse.
 */
public protocol Basis {
    associatedtype Next: Basis
    associatedtype Sign: BasisSign
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
    associatedtype Tail: BasisChain
    associatedtype Current: BasisSign
}
public enum EndBasisChain: BasisChain {
    public typealias Tail = Self
    public typealias Current = Zero
}
public enum MidBasisChain<Current: BasisSign, Tail: BasisChain>: BasisChain { }
