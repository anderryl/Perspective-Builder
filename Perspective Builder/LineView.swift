//
//  LineView.swift
//  Perspective Builder
//
//  Created by Anderson, Todd W. on 12/24/19.
//  Copyright © 2019 Anderson, Todd W. All rights reserved.
//

import Cocoa

class LineView: NSView {
    weak var controller: ViewController?
    
    override func draw(_ dirtyRect: NSRect) {
        guard let context = NSGraphicsContext.current?.cgContext else {
            return
        }
        guard let con = controller else {
            return
        }
        context.setStrokeColor(.white)
        context.setFillColor(.white)
        context.setLineCap(.round)
        context.setLineWidth(5.0)
        for line in con.lines {
            let flat = line.flatten(onto: con.plane)
            context.addLines(between: [flat.start, flat.end])
            context.strokePath()
        }
        if let goal = controller?.goal {
            context.fill(goal.flatten(onto: con.plane))
        }
        if let pos = con.position?.flatten(onto: con.plane) {
            let rect = CGRect(x: pos.x - 5, y: pos.y - 5, width: 10, height: 10)
            context.addEllipse(in: rect)
            context.fillPath()
        }
    }
}
