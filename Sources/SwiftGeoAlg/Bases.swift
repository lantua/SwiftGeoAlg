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

public enum EndChain: BasisChain {
    public typealias MultiVector = Scalar
}
public enum Chained<Current: Basis, Next: BasisChain>: BasisChain {
    public typealias MultiVector = Vector<Next.MultiVector, Next.MultiVector>
}

// MARK: Parity

public protocol ParityBasisChain {
    associatedtype Odd: VectorStorage = Empty
    associatedtype Even: VectorStorage = Empty
}
extension EndChain: ParityBasisChain {
    public typealias Even = Scalar
}
extension Chained: ParityBasisChain where Next: ParityBasisChain {
    public typealias Odd = Vector<Next.Even, Next.Odd>
    public typealias Even = Vector<Next.Odd, Next.Even>
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
extension EndChain: GradedBasisChain {
    public typealias Grade0 = Scalar
}
extension Chained: GradedBasisChain where Next: GradedBasisChain {
    public typealias Grade0 = Vector<Empty, Next.Grade0>
    public typealias Grade1 = Vector<Next.Grade0, Next.Grade1>
    public typealias Grade2 = Vector<Next.Grade1, Next.Grade2>
    public typealias Grade3 = Vector<Next.Grade2, Next.Grade3>
    public typealias Grade4 = Vector<Next.Grade3, Next.Grade4>
    public typealias Grade5 = Vector<Next.Grade4, Next.Grade5>
    public typealias Grade6 = Vector<Next.Grade5, Next.Grade6>
    public typealias Grade7 = Vector<Next.Grade6, Next.Grade7>
    public typealias Grade8 = Vector<Next.Grade7, Next.Grade8>
}

// MARK: Helpers

public typealias Base1<B1: Basis> = Chained<B1, EndChain>
public typealias Base2<B1: Basis, B2: Basis> = Chained<B1, Base1<B2>>
public typealias Base3<B1: Basis, B2: Basis, B3: Basis> = Chained<B1, Base2<B2, B3>>
public typealias Base4<B1: Basis, B2: Basis, B3: Basis, B4: Basis> = Chained<B1, Base3<B2, B3, B4>>
public typealias Base5<B1: Basis, B2: Basis, B3: Basis, B4: Basis, B5: Basis> = Chained<B1, Base4<B2, B3, B4, B5>>
public typealias Bases<B1: Basis, B2: Basis, B3: Basis, B4: Basis, B5: Basis, Tail: BasisChain> =
    Chained<B1, Chained<B2, Chained<B3, Chained<B4, Chained<B5, Tail>>>>>
