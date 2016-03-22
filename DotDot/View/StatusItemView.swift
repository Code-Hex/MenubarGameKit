//
//  StatusItemView.swift
//  Popup
//
//  Created by CodeHex on 2016/03/21.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Cocoa

class StatusItemView: NSView {
    private var _image = NSImage()
    private var _alternateImage = NSImage()
    private var _statusItem = NSStatusItem()
    private var _isHighlighted = false
    var target: AnyObject?
    var action = ""
    
    var image: NSImage {
        get {
            return self._image
        }
        
        set(newImage) {
            if self._image != newImage {
                self._image = newImage
                self.needsDisplay = true
            }
        }
    }
    
    var statusItem: NSStatusItem {
        get {
            return self._statusItem
        }
        
        set(newItem) {
            self._statusItem = newItem
        }
    }
    
    var isHighlighted: Bool {
        get {
            return self._isHighlighted
        }
        
        set(newFlag) {
            if self._isHighlighted != newFlag {
                self._isHighlighted = newFlag
                self.needsDisplay = true
            }
        }
    }
    
    var alternateImage: NSImage {
        get {
            return self._alternateImage
        }
        
        set(newImage) {
            if self._alternateImage != newImage {
                self._alternateImage = newImage
                if self.isHighlighted {
                    self.needsDisplay = true
                }
            }
        }
    }
    
    var globalRect: NSRect? {
        return self.window?.convertRectToScreen(self.frame)
    }
    
    init(statusItem: NSStatusItem) {
        let itemWidth = statusItem.length
        let itemHeight = NSStatusBar.systemStatusBar().thickness
        let itemRect = NSMakeRect(0.0, 0.0, itemWidth, itemHeight)
        super.init(frame: itemRect)
        _statusItem = statusItem
        _statusItem.view = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(dirtyRect: NSRect) {
        let ud = NSUserDefaults.standardUserDefaults()
        if ud.stringForKey("AppleInterfaceStyle") == "Dark" {
            self.image = NSImage(named: "StatusHighlighted")!
        } else {
            self.image = self.isHighlighted ? NSImage(named: "StatusHighlighted")! : NSImage(named: "Status")!
        }
        
        self.statusItem.drawStatusBarBackgroundInRect(dirtyRect, withHighlight: self.isHighlighted)

        let icon = self.image
        let iconSize = icon.size
        let bounds = self.bounds
        let n: CGFloat = 2.0
        let iconX = roundf(Float((bounds.width - iconSize.width) / n))
        let iconY = roundf(Float((bounds.height - iconSize.height) / n))
        let iconPoint = NSMakePoint(CGFloat(iconX), CGFloat(iconY))
        
        icon.drawAtPoint(iconPoint, fromRect: NSZeroRect, operation: .CompositeSourceOver, fraction: 1.0)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        NSApp.sendAction(Selector(self.action), to: self.target, from: self)
    }
}
