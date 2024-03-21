//
//  NSViewExt.swift
//  Kaguya
//
//  Created by Feng Dawei on 2024/3/21.
//

import Foundation
import AppKit
extension NSView {
    var getOrigin:CGPoint? {
        return self.window?.frame.origin
    }
}
