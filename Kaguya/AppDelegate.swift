//
//  AppDelegate.swift
//  Kaguya
//
//  Created by 冯大纬 on 2024/3/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    private let menu_bar = MenuBar()


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

