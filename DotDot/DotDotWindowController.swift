//
//  DotDotWindowController.swift
//  DotDot
//
//  Created by CodeHex on 2016/03/21.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Cocoa

class DotDotWindowController: NSWindowController, NSWindowDelegate
{
    private let OPEN_DURATION = 0.15
    private let CLOSE_DURATION = 0.1
    
    private var _hasActivePanel = false
    private var _delegate: DotDotWindowControllerDelegate?
    
    @IBOutlet weak var backgroundView: BackgroundView!
    
    var delegate: DotDotWindowControllerDelegate {
        return _delegate!
    }
    
    dynamic var hasActivePanel: Bool {
        get {
            return self._hasActivePanel
        }
        
        set(flag) {
            if _hasActivePanel != flag {
                _hasActivePanel = flag
                if _hasActivePanel {
                    self.openPanel(width: 280, height: 122)
                } else {
                    self.closePanel()
                }
            }
        }
    }
    
    convenience init(delegate: DotDotWindowControllerDelegate) {
        self.init(windowNibName: "GamePanel")
        _delegate = delegate
    }

    override init(window: NSWindow?) {
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let panel = self.window!
        panel.acceptsMouseMovedEvents = true
        panel.level = Int(CGWindowLevelKey.PopUpMenuWindowLevelKey.rawValue)
        panel.opaque = false
        panel.backgroundColor = NSColor.clearColor()
    }
    
    // MARK: NSWindowDelegate
    
    func windowWillClose(notification: NSNotification) {
        self.hasActivePanel = false
    }
    
    func windowDidResignKey(notification: NSNotification) {
        if self.window!.visible {
            self.hasActivePanel = false
        }
    }
    
    func windowDidResize(notification: NSNotification) {
        let panel = self.window!
        let statusRect = self.statusRectForWindow(panel)
        let panelRect = panel.frame
        
        let statusX = CGFloat(roundf(Float(statusRect.midX)))
        let panelX = statusX - panelRect.minX
        
        self.backgroundView.arrowX = panelX
        
    }
    
    // MARK: Public methods
    func statusRectForWindow(window: NSWindow) -> NSRect {
        let screenRect = NSScreen.mainScreen()!.frame
        var statusRect = NSZeroRect
        
        var statusItemView: StatusItemView?
        
        if self.delegate.respondsToSelector("statusItemViewForPanelController:") {
            statusItemView = self.delegate.statusItemViewForPanelController(self)
        }
        
        if statusItemView != nil {
            statusRect = statusItemView!.globalRect!
            statusRect.origin.y = statusRect.minY - statusRect.height
        } else {
            statusRect.size = NSMakeSize(STATUS_ITEM_VIEW_WIDTH, NSStatusBar.systemStatusBar().thickness)
            statusRect.origin.x = CGFloat(roundf(Float(screenRect.width - statusRect.width) / 2))
            statusRect.origin.y = screenRect.height - statusRect.height * 2
        }
        
        return statusRect
    }
    
    func openPanel(width width: CGFloat, height: CGFloat) {
        let panel = self.window!
        let screenRect = NSScreen.mainScreen()!.frame
        let statusRect = self.statusRectForWindow(panel)
        var panelRect = panel.frame
        
        panelRect.size.width = width
        panelRect.size.height = height
        
        panelRect.origin.x = CGFloat(roundf(Float(statusRect.midX - panelRect.width / 2)))
        panelRect.origin.y = statusRect.maxY - panelRect.height
        
        if panelRect.maxX > (screenRect.maxX - ARROW_HEIGHT) {
            panelRect.origin.x -= panelRect.maxX - (screenRect.maxX - ARROW_HEIGHT)
        }
        
        NSApp.activateIgnoringOtherApps(false)
        panel.alphaValue = 0
        panel.setFrame(statusRect, display: true)
        panel.makeKeyAndOrderFront(nil)
        
        var openDuration = OPEN_DURATION
        let currentEvent = NSApp.currentEvent!
        
        if currentEvent.type == .LeftMouseDown {
            let clearFlags = currentEvent.modifierFlags.union([])
            
            let shiftPressed: Bool = clearFlags.isSupersetOf(.ShiftKeyMask)
            let shiftOptionPressed: Bool = clearFlags.isSupersetOf([.ShiftKeyMask, .AlternateKeyMask])
            
            if shiftPressed || shiftOptionPressed {
                openDuration *= 10
                if shiftOptionPressed {
                    print("Icon is at " + NSStringFromRect(statusRect) + "\n\tMenu is on screen " + NSStringFromRect(screenRect) + "\n\tWill be animated to " + NSStringFromRect(panelRect))
                }
            }
        }
        
        NSAnimationContext.beginGrouping()
        NSAnimationContext.currentContext().duration = openDuration
        panel.animator().setFrame(panelRect, display: true)
        panel.animator().alphaValue = 1
        NSAnimationContext.endGrouping()
        // panel.performSelector(Selector("makeFirstResponder"), withObject: self, afterDelay: openDuration)
    }
    
    func closePanel() {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.currentContext().duration = CLOSE_DURATION
        self.window!.animator().alphaValue = 0
        NSAnimationContext.endGrouping()
        
        dispatch_after(dispatch_walltime(nil, Int64(NSEC_PER_SEC * UInt64(CLOSE_DURATION) * 2)), dispatch_get_main_queue(), {
            self.window!.orderOut(nil)
        })
    }
}
