//
//  Bases.swift
//  
//
//  Created by Natchanon Luangsomboon on 28/5/2563 BE.
//

import Foundation

/// Most algorithms require that it also conforms to ONE-AND-ONLY-ONE of `PositiveBasis`, `NegativeBasis`, `ZeroBasis.`
public protocol Basis { }
public protocol PositiveBasis: Basis { }
public protocol NegativeBasis: Basis { }
public protocol ZeroBasis: Basis { }

public protocol BasisChain {
    associatedtype MultiVector: VectorStorage
}

public enum Last: BasisChain {
    public typealias MultiVector = Scalar
}
public enum Chained<Current: Basis, Next: BasisChain>: BasisChain {
    public typealias MultiVector = Vector<Current, Next.MultiVector, Next.MultiVector>
}

// MARK: Parity

public protocol ParityBasisChain {
    associatedtype Odd: VectorStorage = Empty
    associatedtype Even: VectorStorage = Empty
}
extension Last: ParityBasisChain {
    public typealias Even = Scalar
}
extension Chained: ParityBasisChain where Next: ParityBasisChain {
    public typealias Odd = Vector<Current, Next.Even, Next.Odd>
    public typealias Even = Vector<Current, Next.Odd, Next.Even>
}

// MARK: Grading

public protocol GradedBasisChain {
    associatedtype Grade0: VectorStorage = Empty
    associatedtype Grade1: VectorStorage = Empty
    associatedtype Grade2: VectorStorage = Empty
    associatedtype Grade3: VectorStorage = Empty
    associatedtype Grade4: VectorStorage = Empty
    associatedtype Grade5: VectorStorage = Empty
    associatedtype Grade6: VectorStorage = Empty
    associatedtype Grade7: VectorStorage = Empty
    associatedtype Grade8: VectorStorage = Empty
}
extension Last: GradedBasisChain {
    public typealias Grade0 = Scalar
}
extension Chained: GradedBasisChain where Next: GradedBasisChain {
    public typealias Grade0 = Vector<Current, Empty, Next.Grade0>
    public typealias Grade1 = Vector<Current, Next.Grade0, Next.Grade1>
    public typealias Grade2 = Vector<Current, Next.Grade1, Next.Grade2>
    public typealias Grade3 = Vector<Current, Next.Grade2, Next.Grade3>
    public typealias Grade4 = Vector<Current, Next.Grade3, Next.Grade4>
    public typealias Grade5 = Vector<Current, Next.Grade4, Next.Grade5>
    public typealias Grade6 = Vector<Current, Next.Grade5, Next.Grade6>
    public typealias Grade7 = Vector<Current, Next.Grade6, Next.Grade7>
    public typealias Grade8 = Vector<Current, Next.Grade7, Next.Grade8>
}

public typealias Bases2<B1: Basis, B2: Basis> = Chained<B1, Chained<B2, Last>>
public typealias Bases<B1: Basis, B2: Basis, B3: Basis, Tail: BasisChain> = Chained<B1, Chained<B2, Chained<B3, Tail>>>
