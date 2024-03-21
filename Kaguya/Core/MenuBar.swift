//
//  MenuBar.swift
//  Kaguya
//
//  Created by Feng Dawei on 2024/3/21.
//

import AppKit

class MenuBar {
//  Member Variables
    private let kaguya = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let seperator = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var expand = true
    
//  Member Functions
    init() {
        init_ui()
    }
    
    private func init_ui() {
        if let button = self.kaguya.button {
            button.title = "Hide"
            button.image = NSImage(named: "KaguyaIcon")
            button.target = self
            button.action = #selector(self.handleClickOnKaguya(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        if let button = seperator.button {
            button.image = NSImage(named: "SeperatorIcon")
        }
    }

//  Guard the seperator always be at the left side of kaguya icon
    private func isKaguyaPositionValid()->Bool {
        guard
            let kaguyaPosition = self.kaguya.button?.getOrigin?.x,
            let seperatorPosition = self.seperator.button?.getOrigin?.x
            else {return false}
        return kaguyaPosition >= seperatorPosition
    }
    
    @objc func handleClickOnKaguya(sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
            if event.type == NSEvent.EventType.rightMouseUp {
//                print("Right click, self.showKaguyaMenu()")
                self.showKaguyaMenu()
            } else {
//                print("Left click, self.switchStatus()")
                self.switchStatus()
            }
    }
    
    @objc func switchStatus() {
        if self.isKaguyaPositionValid() {
            self.expand = !self.expand
            seperator.length = self.expand ? NSStatusItem.variableLength : 10000
            if let button = kaguya.button {
                button.title = self.expand ? "Hide" : "Show"
            }
        }
    }
    
    @objc func toggleAutoHide() {
//    To be implemented.
    }
    
    private func showKaguyaMenu() {
        let menu = NSMenu()
        
        let switchStatusItem = NSMenuItem(title: "Switch", action: #selector(self.switchStatus), keyEquivalent: "s")
        switchStatusItem.target = self
        menu.addItem(switchStatusItem)
        
        let toggleAutoHideItem = NSMenuItem(title: "Toggle Auto Hide", action: #selector(self.toggleAutoHide), keyEquivalent: "t")
        toggleAutoHideItem.target = self
        menu.addItem(toggleAutoHideItem)
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        self.kaguya.menu = menu
        self.kaguya.button?.performClick(nil)
        self.kaguya.menu = nil
    }
}
