//
//  ProductChain.swift
//  
//
//  Created by Natchanon Luangsomboon on 27/5/2563 BE.
//

import Foundation

public enum KVectorTooMany: ProductChain { public typealias Next = Self }
public enum KVectorChain<Next: ProductChain>: ProductChain { }
public enum KVectorChainEnd: ProductChain {
    public typealias Next = KVectorTooMany
    public typealias Storage = Scalar
}

public typealias Vector0Chain = KVectorChainEnd
public typealias Vector1Chain = KVectorChain<Vector0Chain>
public typealias Vector2Chain = KVectorChain<Vector1Chain>
public typealias Vector3Chain = KVectorChain<Vector2Chain>
public typealias Vector4Chain = KVectorChain<Vector3Chain>
public typealias Vector5Chain = KVectorChain<Vector4Chain>
public typealias Vector6Chain = KVectorChain<Vector5Chain>
public typealias Vector7Chain = KVectorChain<Vector6Chain>
public typealias Vector8Chain = KVectorChain<Vector7Chain>

/// All terms included.
public enum MultiVectorChain: ProductChain {
    public typealias Next = Self
    public typealias Storage = Scalar
}

public enum EvenVectorChain: ProductChain {
    public typealias Next = OddVectorChain
    public typealias Storage = Scalar
}
public enum OddVectorChain: ProductChain {
    public typealias Next = EvenVectorChain
}
