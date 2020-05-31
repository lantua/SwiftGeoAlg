//
//  Meta.swift
//  
//
//  Created by Natchanon Luangsomboon on 31/5/2563 BE.
//

public protocol ProductFilter {
    associatedtype Left: ProductFilter = FilterReject
    associatedtype Right: ProductFilter = FilterReject
    associatedtype Both: ProductFilter = FilterReject
}

public enum FilterReject: ProductFilter { }

public enum GeometricProduct: ProductFilter {
    public typealias Left = GeometricProduct
    public typealias Right = GeometricProduct
    public typealias Both = GeometricProduct
}

public enum OuterProduct: ProductFilter {
    public typealias Left = OuterProduct
    public typealias Right = OuterProduct
}

public enum LeftInnerProduct: ProductFilter {
    public typealias Right = LeftInnerProduct
    public typealias Both = LeftInnerProduct
}

public enum RightInnerProduct: ProductFilter {
    public typealias Left = RightInnerProduct
    public typealias Both = RightInnerProduct
}

public enum FatDotProduct: ProductFilter {
    public typealias Left = RightInnerProduct
    public typealias Right = LeftInnerProduct
    public typealias Both = FatDotProduct
}

public enum ScalarProduct: ProductFilter {
    public typealias Both = ScalarProduct
}

public protocol MetaBool {
    associatedtype Toggle: MetaBool
    static var value: Bool { get }
}

public enum MetaTrue: MetaBool {
    public typealias Toggle = MetaFalse
    public static var value: Bool { true }
}
public enum MetaFalse: MetaBool {
    public typealias Toggle = MetaTrue
    public static var value: Bool { false }
}
