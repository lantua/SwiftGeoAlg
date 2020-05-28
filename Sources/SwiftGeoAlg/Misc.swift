//
//  File.swift
//  
//
//  Created by Natchanon Luangsomboon on 28/5/2563 BE.
//

import Foundation

func unreachable(file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("Unreachable. If you receive this message, please file bug report.", file: file, line: line)
}
