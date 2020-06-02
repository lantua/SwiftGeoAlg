//
//  StorageAliases.swift
//  
//
//  Created by Natchanon Luangsomboon on 29/5/2563 BE.
//

public protocol StorageAliases {
    associatedtype Reduced: StorageAliases

    typealias Grade0 = Scalar
    associatedtype Even: Storage = _Even<Self>
    associatedtype Odd: Storage = _Odd<Self>
    associatedtype Full: Storage = _Full<Self>

    associatedtype Grade1: Storage = _Grade1<Self>
    associatedtype Grade2: Storage = _Grade2<Self>
    associatedtype Grade3: Storage = _Grade3<Self>
    associatedtype Grade4: Storage = _Grade4<Self>
    associatedtype Grade5: Storage = _Grade5<Self>
}
public typealias _Even<S: StorageAliases> = Mixed<S.Reduced.Odd, S.Reduced.Even>
public typealias _Odd<S: StorageAliases> = Mixed<S.Reduced.Even, S.Reduced.Odd>
public typealias _Full<S: StorageAliases> = Mixed<S.Reduced.Full, S.Reduced.Full>
public typealias _Grade1<S: StorageAliases> = Mixed<Scalar, S.Reduced.Grade1>
public typealias _Grade2<S: StorageAliases> = Mixed<S.Reduced.Grade1, S.Reduced.Grade2>
public typealias _Grade3<S: StorageAliases> = Mixed<S.Reduced.Grade2, S.Reduced.Grade3>
public typealias _Grade4<S: StorageAliases> = Mixed<S.Reduced.Grade3, S.Reduced.Grade4>
public typealias _Grade5<S: StorageAliases> = Mixed<S.Reduced.Grade4, S.Reduced.Grade5>

public enum Storage1D: StorageAliases {
    public typealias Reduced = Self
    public typealias Even = Empty
    public typealias Odd = Scalar
    public typealias Full = Mixed<Scalar, Scalar>

    public typealias Grade1 = Mixed<Grade0, Empty>
    public typealias Grade2 = Empty
    public typealias Grade3 = Empty
    public typealias Grade4 = Empty
    public typealias Grade5 = Empty
}

public enum Storage2D: StorageAliases {
    public typealias Reduced = Storage1D

    public typealias Grade3 = Empty
    public typealias Grade4 = Empty
    public typealias Grade5 = Empty
}

public enum Storage3D: StorageAliases {
    public typealias Reduced = Storage2D

    public typealias Grade4 = Empty
    public typealias Grade5 = Empty
}

public enum Storage4D: StorageAliases {
    public typealias Reduced = Storage3D

    public typealias Grade5 = Empty
}

public enum Storage5D: StorageAliases {
    public typealias Reduced = Storage4D
}
