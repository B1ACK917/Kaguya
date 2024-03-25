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
    private let widthOnHide: CGFloat = 10000
    private var expand = true
    private var autoHide = true
    private var autoHideTimer: Timer?
    
    //  Member Functions
    init() {
        self.initUI()
        self.checkIfNeedStartAutoHide()
    }
    
    private func initUI() {
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
    
    @objc private func handleClickOnKaguya(sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        if event.type == NSEvent.EventType.rightMouseUp {
            self.showKaguyaMenu()
        } else {
            self.switchStatus()
        }
    }
    
    //  Guard the seperator always be at the left side of kaguya icon
    private func isKaguyaPositionValid() -> Bool {
        guard
            let kaguyaPosition = self.kaguya.button?.getOrigin?.x,
            let seperatorPosition = self.seperator.button?.getOrigin?.x
        else {return false}
        return kaguyaPosition >= seperatorPosition
    }
    
    @objc private func switchStatus() {
        if self.isKaguyaPositionValid() {
            self.expand = !self.expand
            seperator.length = self.expand ? NSStatusItem.variableLength : self.widthOnHide
            kaguya.button?.title = self.expand ? "Hide" : "Show"
            self.checkIfNeedStartAutoHide()
        }
    }
    
    @objc private func switchToHide() {
        if self.isKaguyaPositionValid() {
            self.expand = false
            seperator.length = self.widthOnHide
            kaguya.button?.title = "Show"
        }
        self.destroyAutoHideTimer()
    }
    
    private func destroyAutoHideTimer() {
        self.autoHideTimer?.invalidate()
        self.autoHideTimer = nil
    }
    
    private func checkIfNeedStartAutoHide() {
        if !self.autoHide {
            self.destroyAutoHideTimer()
        }
        else {
            if self.isKaguyaPositionValid() && self.expand && (self.autoHideTimer == nil) {
                self.autoHideTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.switchToHide), userInfo: nil, repeats: false)
            }
        }
    }
    
    @objc private func toggleAutoHide() {
        self.autoHide = !self.autoHide
        self.checkIfNeedStartAutoHide()
    }
    
    private func showKaguyaMenu() {
        let menu = NSMenu()
        
        let switchStatusItem = NSMenuItem(title: "Switch", action: #selector(self.switchStatus), keyEquivalent: "s")
        switchStatusItem.target = self
        menu.addItem(switchStatusItem)
        
        let autoHideStatus = self.autoHide ? "On" : "Off"
        let toggleAutoHideItem = NSMenuItem(title: "Toggle Auto Hide (\(autoHideStatus))", action: #selector(self.toggleAutoHide), keyEquivalent: "t")
        toggleAutoHideItem.target = self
        menu.addItem(toggleAutoHideItem)
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        self.kaguya.menu = menu
        self.kaguya.button?.performClick(nil)
        self.kaguya.menu = nil
    }
}
