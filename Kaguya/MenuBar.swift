//
//  MenuBar.swift
//  Kaguya
//
//  Created by 冯大纬 on 2024/3/21.
//

import AppKit

class MenuBar {
    private let kaguya = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let seperator = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var expand = true
    
    init() {
        init_ui()
    }
    
    private func init_ui() {
        if let button = kaguya.button {
            button.title = "Hide"
            button.image = NSImage(named: "KaguyaIcon")
            button.target = self
            button.action = #selector(self.switchStatus(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        if let button = seperator.button {
            button.image = NSImage(named: "SeperatorIcon")
        }
    }
    
    @objc func switchStatus(sender: NSStatusBarButton) {
        self.expand = !self.expand
        seperator.length = self.expand ? NSStatusItem.variableLength : 10000
        if let button = kaguya.button {
            button.title = self.expand ? "Hide" : "Show"
        }
    }
}
