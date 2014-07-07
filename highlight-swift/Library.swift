//
//  Library.swift
//  highlight-swift
//
//  Created by Chris Eidhof on 07/07/14.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

import Foundation

func exec(#commandPath: String, #workingDirectory: String?, #arguments: String[]) -> (stdout: String, stderr: String) {
    let task = NSTask()
    task.currentDirectoryPath = workingDirectory
    task.launchPath = commandPath
    task.arguments = arguments
    task.environment = ["PATH": "/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin"]
    
    let stdout = NSPipe()
    task.standardOutput = stdout
    let stderr = NSPipe()
    task.standardError = stderr
    
    task.launch()
    
    func read(pipe: NSPipe) -> String {
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return NSString(data: data, encoding: NSUTF8StringEncoding)
    }
    let stdoutoutput : String = read(stdout)
    let stderroutput : String = read(stderr)
    
    task.waitUntilExit()
    
    return (stdout: stdoutoutput, stderr: stderroutput)
}