//
//  MenubarController.swift
//  Popup
//
//  Created by CodeHex on 2016/03/21.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Cocoa

@objc(StatusItemView)
class MenubarController : NSObject {
    private var _statusItemView: StatusItemView?
    
    var statusItemView: StatusItemView {
        return _statusItemView!
    }
    
    var statusItem: NSStatusItem {
        return self.statusItemView.statusItem
    }
    
    var hasActiveIcon: Bool {
        get {
            return self.statusItemView.isHighlighted
        }
        set(flag) {
            self.statusItemView.isHighlighted = flag
        }
    }
    
    override init() {
        super.init()
        let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(STATUS_ITEM_VIEW_WIDTH)
        _statusItemView = StatusItemView(statusItem: statusItem)
        _statusItemView!.image = NSImage(named: "Status")!
        _statusItemView!.alternateImage = NSImage(named: "StatusHighlighted")!
        _statusItemView!.action = "togglePanel"
    }
    
    deinit {
        NSStatusBar.systemStatusBar().removeStatusItem(self.statusItem)
    }
}
