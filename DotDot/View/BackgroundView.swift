//
//  BackgroundView.swift
//  Popup
//
//  Created by CodeHex on 2016/03/21.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Cocoa

class BackgroundView: NSView {
    
    private var _arrowX: CGFloat = 0
    
    var arrowX: CGFloat {
        get {
            return self._arrowX
        }
        set(newVal) {
            self._arrowX = newVal
            self.needsDisplay = true
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        
        let contentRect = NSInsetRect(self.bounds, LINE_THICKNESS, LINE_THICKNESS)
        let path = NSBezierPath(rect: dirtyRect)
        
        path.moveToPoint(NSMakePoint(arrowX, contentRect.maxY))
        path.lineToPoint(NSMakePoint(_arrowX + ARROW_WIDTH / 2, contentRect.maxY - ARROW_HEIGHT))
        path.lineToPoint(NSMakePoint(contentRect.maxX - CORNER_RADIUS, contentRect.maxY - ARROW_HEIGHT))
        
        let topRightCorner = NSMakePoint(contentRect.maxX, contentRect.maxY - ARROW_HEIGHT)
        
        path.curveToPoint(NSMakePoint(contentRect.maxX, contentRect.maxY - ARROW_HEIGHT - CORNER_RADIUS), controlPoint1: topRightCorner, controlPoint2: topRightCorner)
        path.lineToPoint(NSMakePoint(contentRect.maxX, contentRect.minY + CORNER_RADIUS))
        
        let bottomRightCorner = NSMakePoint(contentRect.maxX, contentRect.minY)
        
        path.curveToPoint(NSMakePoint(contentRect.maxX - CORNER_RADIUS, contentRect.minY), controlPoint1: bottomRightCorner, controlPoint2: bottomRightCorner)
        path.lineToPoint(NSMakePoint(contentRect.minX + CORNER_RADIUS, contentRect.minY))
        path.curveToPoint(NSMakePoint(contentRect.minX, contentRect.minY + CORNER_RADIUS), controlPoint1: contentRect.origin, controlPoint2: contentRect.origin)
        path.lineToPoint(NSMakePoint(contentRect.minX, contentRect.maxY - ARROW_HEIGHT - CORNER_RADIUS))
        
        let topLeftCorner = NSMakePoint(contentRect.minX, contentRect.maxY - ARROW_HEIGHT)
        
        path.curveToPoint(NSMakePoint(contentRect.minX + CORNER_RADIUS, contentRect.maxY - ARROW_HEIGHT), controlPoint1: topLeftCorner, controlPoint2: topLeftCorner)
        
        path.lineToPoint(NSMakePoint(_arrowX - ARROW_WIDTH / 2, contentRect.maxY - ARROW_HEIGHT))
        path.closePath()
        NSColor(deviceWhite: 1.0, alpha: FILL_OPACITY).setFill()
        path.fill()
        
        NSGraphicsContext.saveGraphicsState()
        
        let clip = NSBezierPath(rect: self.bounds)
        clip.appendBezierPath(path)
        clip.addClip()

        path.lineWidth = LINE_THICKNESS * 2
        NSColor.whiteColor().setStroke()
        path.stroke()
        
        NSGraphicsContext.restoreGraphicsState()
    }
}
