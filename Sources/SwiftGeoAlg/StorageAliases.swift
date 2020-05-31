//
//  StorageAliases.swift
//  
//
//  Created by Natchanon Luangsomboon on 29/5/2563 BE.
//

public typealias Vector0 = Scalar

public typealias Vector1D = Mixed<Vector0 , Vector0>
public typealias Vector2D = Mixed<Vector1D, Vector1D>
public typealias Vector3D = Mixed<Vector2D, Vector2D>
public typealias Vector4D = Mixed<Vector3D, Vector3D>
public typealias Vector5D = Mixed<Vector4D, Vector4D>
public typealias Vector6D = Mixed<Vector5D, Vector5D>
public typealias Vector7D = Mixed<Vector6D, Vector6D>

public typealias OddVector0D = Empty
public typealias OddVector1D = Mixed<EvenVector0D, OddVector0D>
public typealias OddVector2D = Mixed<EvenVector1D, OddVector1D>
public typealias OddVector3D = Mixed<EvenVector2D, OddVector2D>
public typealias OddVector4D = Mixed<EvenVector3D, OddVector3D>
public typealias OddVector5D = Mixed<EvenVector4D, OddVector4D>
public typealias OddVector6D = Mixed<EvenVector5D, OddVector5D>
public typealias OddVector7D = Mixed<EvenVector6D, OddVector6D>

public typealias EvenVector0D = Scalar
public typealias EvenVector1D = Mixed<OddVector0D, EvenVector0D>
public typealias EvenVector2D = Mixed<OddVector1D, EvenVector1D>
public typealias EvenVector3D = Mixed<OddVector2D, EvenVector2D>
public typealias EvenVector4D = Mixed<OddVector3D, EvenVector3D>
public typealias EvenVector5D = Mixed<OddVector4D, EvenVector4D>
public typealias EvenVector6D = Mixed<OddVector5D, EvenVector5D>
public typealias EvenVector7D = Mixed<OddVector6D, EvenVector6D>

public typealias Vector1_1D = Mixed<Vector0   , Empty>

public typealias Vector1_2D = Mixed<Vector0   , Vector1_1D>
public typealias Vector2_2D = Mixed<Vector1_1D, Empty>

public typealias Vector1_3D = Mixed<Vector0   , Vector1_2D>
public typealias Vector2_3D = Mixed<Vector1_2D, Vector2_2D>
public typealias Vector3_3D = Mixed<Vector2_2D, Empty>

public typealias Vector1_4D = Mixed<Vector0   , Vector1_3D>
public typealias Vector2_4D = Mixed<Vector1_3D, Vector2_3D>
public typealias Vector3_4D = Mixed<Vector2_3D, Vector3_3D>
public typealias Vector4_4D = Mixed<Vector3_3D, Empty>

public typealias Vector1_5D = Mixed<Vector0   , Vector1_4D>
public typealias Vector2_5D = Mixed<Vector1_4D, Vector2_4D>
public typealias Vector3_5D = Mixed<Vector2_4D, Vector3_4D>
public typealias Vector4_5D = Mixed<Vector3_4D, Vector4_4D>
public typealias Vector5_5D = Mixed<Vector4_4D, Empty>

public typealias Vector1_6D = Mixed<Vector0   , Vector1_5D>
public typealias Vector2_6D = Mixed<Vector1_5D, Vector2_5D>
public typealias Vector3_6D = Mixed<Vector2_5D, Vector3_5D>
public typealias Vector4_6D = Mixed<Vector3_5D, Vector4_5D>
public typealias Vector5_6D = Mixed<Vector4_5D, Vector5_5D>
public typealias Vector6_6D = Mixed<Vector5_5D, Empty>

public typealias Vector1_7D = Mixed<Vector0   , Vector1_6D>
public typealias Vector2_7D = Mixed<Vector1_6D, Vector2_6D>
public typealias Vector3_7D = Mixed<Vector2_6D, Vector3_6D>
public typealias Vector4_7D = Mixed<Vector3_6D, Vector4_6D>
public typealias Vector5_7D = Mixed<Vector4_6D, Vector5_6D>
public typealias Vector6_7D = Mixed<Vector5_6D, Vector6_6D>
public typealias Vector7_7D = Mixed<Vector6_6D, Empty>
