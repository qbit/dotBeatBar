//
//  AppDelegate.swift
//  dotBeatBar_old
//
//  Created by Aaron Bieber on 7/26/19.
//  Copyright © 2019 Aaron Bieber. All rights reserved.
//

import Cocoa
import Beat
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var timer = Timer()
    let si = NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength)
    @objc func updateStatBar(_ sender: Any?) {
        if let button = si.button {
            button.title = "@\(Beat(Date().timeIntervalSince1970).text())"
        }
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        updateStatBar(self)
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateStatBar), userInfo: nil, repeats: true)

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action:
            #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        si.menu = menu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        timer.invalidate()
    }
}
