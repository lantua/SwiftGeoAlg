//
//  Misc.swift
//  
//
//  Created by Natchanon Luangsomboon on 28/5/2563 BE.
//

// MARK: Common functions

func unreachable(file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("Unreachable. If you receive this message, please file bug report.", file: file, line: line)
}

// MARK: MetaBool

@usableFromInline protocol MetaBool { associatedtype Toggle: MetaBool }
@usableFromInline enum True: MetaBool { public typealias Toggle = False }
@usableFromInline enum False: MetaBool { public typealias Toggle = True }
