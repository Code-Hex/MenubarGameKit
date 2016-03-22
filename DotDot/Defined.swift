//
//  Defined.swift
//  DotDot
//
//  Created by CodeHex on 2016/03/21.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Foundation

let STATUS_ITEM_VIEW_WIDTH: CGFloat =  24.0
let ARROW_WIDTH: CGFloat = 12
let ARROW_HEIGHT: CGFloat = 8

let FILL_OPACITY: CGFloat = 0.9

let LINE_THICKNESS: CGFloat = 1.0
let CORNER_RADIUS: CGFloat = 6.0

protocol DotDotWindowControllerDelegate: NSObjectProtocol {
    func statusItemViewForPanelController(controller: DotDotWindowController) -> StatusItemView
}