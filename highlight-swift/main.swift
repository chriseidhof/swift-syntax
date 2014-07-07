//
//  main.swift
//  highlight-swift
//
//  Created by Chris Eidhof on 07/07/14.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

import Foundation

var arguments = Process.arguments

func findArgument(name: String) -> Bool {
    if let idx = find(arguments, "-" + name) {
        arguments.removeAtIndex(idx)
        return true
    }
    return false
    
}

let mapping : Dictionary<String,String> = [
    "kw" : "keyword",
    "comment-line": "comment",
    "type": "type",
    "int": "number",
    "str": "string",
    "dollar": ""
]

let filename : String = {
if arguments.count == 1 {
    
    let input = NSFileHandle.fileHandleWithStandardInput()!
    let data: NSData = input.readDataToEndOfFile()!
    let contents = NSString(data:data, encoding:NSUTF8StringEncoding)
    let filename = "/tmp/1.swift"
    contents.writeToFile(filename,atomically:true)
    return filename
} else {
    let filename = arguments[1]
    return filename
}
}()

let args = ["swift-ide-test", "-syntax-coloring" ,"-source-filename", filename]
let (stdout, stderr) = exec(commandPath:"/usr/bin/xcrun", workingDirectory:"/tmp", arguments:args)

var error : NSError? = nil
let openTag = NSRegularExpression(pattern: "<([\\w\\-]+)>", options: nil, error: &error)
let closeTag = "</[\\w\\-]+>"

println("Error: \(error)")
//println("Stdout \(stdout)\n----\n")

let matches = openTag.matchesInString(stdout, options: nil, range: NSMakeRange(0, countElements(stdout))) as NSTextCheckingResult[]
var s : NSString = stdout
for r in (reverse(matches)) {
    let tag = s.substringWithRange(r.rangeAtIndex(1))
    let name : String? = mapping[tag]
    let result = "<span class='\(name ? name : tag)'>"
    s = s.stringByReplacingCharactersInRange(r.rangeAtIndex(0), withString: result)
}
let final  = s.stringByReplacingOccurrencesOfString(closeTag, withString: "</span>", options: .RegularExpressionSearch, range: NSMakeRange(0, countElements(String(s))))


println(final)