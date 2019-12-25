//
//  ViewController.swift
//  Perspective Builder
//
//  Created by Anderson, Todd W. on 12/24/19.
//  Copyright © 2019 Anderson, Todd W. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var lines: [Line] = []
    var goal: Goal?
    var position: Coordinate?
    @IBOutlet weak var x1: NSTextField!
    @IBOutlet weak var y1: NSTextField!
    @IBOutlet weak var z1: NSTextField!
    @IBOutlet weak var x2: NSTextField!
    @IBOutlet weak var y2: NSTextField!
    @IBOutlet weak var z2: NSTextField!
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var namer: NSTextFieldCell!
    var plane: Plane = .XZ
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (view as! LineView).controller = self
    }
    
    @IBAction func enter(_ sender: Any) {
        guard let x1 = Int(x1.stringValue) else {
            return
        }
        guard let y1 = Int(y1.stringValue) else {
            return
        }
        guard let z1 = Int(z1.stringValue) else {
            return
        }
        guard let x2 = Int(x2.stringValue) else {
            return
        }
        guard let y2 = Int(y2.stringValue) else {
            return
        }
        guard let z2 = Int(z2.stringValue) else {
            return
        }
        lines.append(Line(start: Coordinate(x: CGFloat(x1), y: CGFloat(y1), z: CGFloat(z1)), end: Coordinate(x: CGFloat(x2), y: CGFloat(y2), z: CGFloat(z2))))
        reset()
        view.display()
    }
    
    @IBAction func setGoal(_ sender: Any) {
        guard let x1 = Int(x1.stringValue) else {
            return
        }
        guard let y1 = Int(y1.stringValue) else {
            return
        }
        guard let z1 = Int(z1.stringValue) else {
            return
        }
        guard let x2 = Int(x2.stringValue) else {
            return
        }
        guard let y2 = Int(y2.stringValue) else {
            return
        }
        guard let z2 = Int(z2.stringValue) else {
            return
        }
        goal = Goal(origin: Coordinate(x: CGFloat(x1), y: CGFloat(y1), z: CGFloat(z1)), outpost: Coordinate(x: CGFloat(x2), y: CGFloat(y2), z: CGFloat(z2)))
        reset()
        view.display()
    }
    
    @IBAction func setPosition(_ sender: Any) {
        guard let x1 = Int(x1.stringValue) else {
            return
        }
        guard let y1 = Int(y1.stringValue) else {
            return
        }
        guard let z1 = Int(z1.stringValue) else {
            return
        }
        position = Coordinate(x: CGFloat(x1), y: CGFloat(y1), z: CGFloat(z1))
        reset()
        view.display()
    }
    
    func reset() {
        x1.stringValue = "x1"
        x2.stringValue = "x2"
        y1.stringValue = "y1"
        y2.stringValue = "y2"
        z1.stringValue = "z1"
        z2.stringValue = "z2"
    }
    
    @IBAction func xy(_ sender: Any) {
        plane = .XY
        view.display()
    }
    
    @IBAction func xz(_ sender: Any) {
        plane = .XZ
        view.display()
    }
    
    @IBAction func zy(_ sender: Any) {
        plane = .ZY
        view.display()
    }
    
    @IBAction func export(_ sender: Any) {
        download(using: namer.stringValue)
    }
    
    func download(using name: String) {
        let encoder = JSONEncoder()
        if goal == nil || position == nil {
            return
        }
        let level = Level(lines: lines, goal: goal!, position: position!)
        let data = try! encoder.encode(level)
        let path = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!.path + "/" + name + ".json"
        FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
    }
}

