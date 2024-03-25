//
//  MenuBar.swift
//  Kaguya
//
//  Created by Feng Dawei on 2024/3/21.
//

import AppKit
import SwiftUI

class MenuBar {
    
    // Two Icons
    private let kaguya = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let separator = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    // Constant
    private let widthOnHide: CGFloat = 10000
    
    // User Preferences Variables
    @AppStorage("expand") private var expand = true
    @AppStorage("autoHide") private var autoHide = true
    @AppStorage("autoHideInterval") private var autoHideInterval: Double = 5.00
    
    // Runtime Variables
    private var autoHideTimer: Timer?
    
    init() {
        self.initUI()
        self.reRender()
        self.checkIfNeedStartHideTimer()
    }
    
    // Render UI
    private func initUI() {
        if let button = self.kaguya.button {
            button.title = "Hide"
            button.image = NSImage(named: "KaguyaIcon")
            button.target = self
            button.action = #selector(self.handleClickOnKaguya(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        if let button = separator.button {
            button.image = NSImage(named: "SeparatorIcon")
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
            let seperatorPosition = self.separator.button?.getOrigin?.x
        else {return false}
        return kaguyaPosition >= seperatorPosition
    }
    
    private func reRender() {
        if self.isKaguyaPositionValid() {
            separator.length = self.expand ? NSStatusItem.variableLength : self.widthOnHide
            kaguya.button?.title = self.expand ? "Hide" : "Show"
        }
    }
    
    @objc private func switchStatus() {
        self.expand ? self.switchToHide() : self.switchToShow()
    }
    
    private func switchToShow() {
        self.expand = true
        self.checkIfNeedStartHideTimer()
        self.reRender()
    }
    
    @objc private func switchToHide() {
        self.expand = false
        self.autoHideTimer?.invalidate()
        self.autoHideTimer = nil
        self.reRender()
    }
    
    private func checkIfNeedStartHideTimer() {
        if self.expand && self.autoHide && self.autoHideTimer == nil {
            self.autoHideTimer = Timer.scheduledTimer(timeInterval: self.autoHideInterval, target: self, selector: #selector(self.switchToHide), userInfo: nil, repeats: false)
        }
    }
    
    private func checkIfNeedDestroyHideTimer() {
        if !self.autoHide {
            self.autoHideTimer?.invalidate()
            self.autoHideTimer = nil
        }
    }
    
    @objc private func toggleAutoHide() {
        self.autoHide = !self.autoHide
        self.checkIfNeedStartHideTimer()
        self.checkIfNeedDestroyHideTimer()
    }
    
    @objc private func changeAutoHideInterval(sender: NSMenuItem) {
        self.autoHideInterval = Double(sender.tag)
    }
    
    private func showKaguyaMenu() {
        let menu = NSMenu()
        
        let autoHideStatus = self.autoHide ? "On" : "Off"
        let toggleAutoHideItem = NSMenuItem(title: "Toggle Auto Hide", action: #selector(self.toggleAutoHide), keyEquivalent: "t")
        if #available(macOS 14.0, *) {
            toggleAutoHideItem.badge = NSMenuItemBadge(string: autoHideStatus)
        } else {
            toggleAutoHideItem.title += " (\(autoHideStatus))"
        }
        toggleAutoHideItem.target = self
        menu.addItem(toggleAutoHideItem)
        
        let hideIntervalControlItem = NSMenuItem(title: "Hide Interval", action: nil, keyEquivalent: "")
        let hideIntervalSubMenu = NSMenu()
        for hideInterval in [5, 10, 15, 30, 60] {
            let menuItem = NSMenuItem(title: "\(hideInterval) Secs", action: #selector(self.changeAutoHideInterval(sender:)), keyEquivalent: "")
            menuItem.tag = hideInterval
            menuItem.target = self
            hideIntervalSubMenu.addItem(menuItem)
        }
        hideIntervalControlItem.submenu = hideIntervalSubMenu
        menu.addItem(hideIntervalControlItem)
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        self.kaguya.menu = menu
        self.kaguya.button?.performClick(nil)
        self.kaguya.menu = nil
    }
}
