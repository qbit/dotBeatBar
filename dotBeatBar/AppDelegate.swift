//
//  AppDelegate.swift
//  dotBeatBar
//
//  Created by Aaron Bieber on 7/26/19.
//  Copyright © 2019 Aaron Bieber. All rights reserved.
//

import Beat
import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let dnc = DistributedNotificationCenter.default()
    var timer = Timer()
    
    let si = NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength)
    
    @objc func updateStatBar(_ sender: Any?) {
        if let button = si.button {
            button.title = "@\(Beat().text())"
        }
    }
    
    func runTask(cmd: String, args: Array<String>) {
        let task = Process()
        let pipe = Pipe()
        
        NSLog("Running '\(cmd)' with '\(args.joined(separator: ", "))'")
        task.executableURL = URL(fileURLWithPath: "\(cmd)")
        task.arguments = args
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)

        NSLog(output! as String)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        updateStatBar(self)
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateStatBar),
                                     userInfo: nil,
                                     repeats: true)

        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Quit", action:
            #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        si.menu = menu
        
        _ = dnc.addObserver(forName: .init("com.apple.screenIsLocked"),
                                       object: nil, queue: .main) { _ in
            NSLog("Screen Locked.")
            self.runTask(cmd: "/usr/bin/ssh-add", args: ["-D"])
            self.runTask(cmd: "/usr/bin/sudo", args: ["-K"])
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        timer.invalidate()
    }
}
