//
//  AppDelegate.swift
//  DotDot
//
//  Created by CodeHex on 2016/03/21.
//  Copyright (c) 2016年 CodeHex. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, DotDotWindowControllerDelegate {
    
    let key = "hasActivePanel"
    var kContextActivePanel = UnsafeMutablePointer<Void>()
    
    var menubarController: MenubarController?
    var _panelController: DotDotWindowController?
    
    var panelController: DotDotWindowController {
        if _panelController == nil {
            _panelController = DotDotWindowController(delegate: self)
            _panelController!.addObserver(self, forKeyPath: key, options: .Old, context: kContextActivePanel)
        }
        return self._panelController!
    }
    
    deinit {
        _panelController!.removeObserver(self, forKeyPath: key)
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        menubarController = MenubarController()
    }
    
    func applicationShouldTerminate(sender: NSApplication) -> NSApplicationTerminateReply {
        self.menubarController = nil
        return .TerminateNow
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == kContextActivePanel {
            self.menubarController!.hasActiveIcon = self.panelController.hasActivePanel
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: ofObject, change: change, context: context)
        }
    }
    
    func togglePanel() {
        self.menubarController!.hasActiveIcon = !self.menubarController!.hasActiveIcon
        self.panelController.hasActivePanel = self.menubarController!.hasActiveIcon
    }

    
    func statusItemViewForPanelController(controller: DotDotWindowController) -> StatusItemView {
        return self.menubarController!.statusItemView
    }
}
