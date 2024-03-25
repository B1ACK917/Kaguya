//
//  AppDelegate.swift
//  Kaguya
//
//  Created by Feng Dawei on 2024/3/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let menu_bar = MenuBar()
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Initializing
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Tearing down
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    
}

