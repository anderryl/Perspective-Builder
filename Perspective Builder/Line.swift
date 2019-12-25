//
//  Line.swift
//  Perspective Builder
//
//  Created by Anderson, Todd W. on 12/24/19.
//  Copyright © 2019 Anderson, Todd W. All rights reserved.
//

import Foundation
import CoreGraphics

class Level: Codable {
    let lines: [Line]
    let goal: Goal
    let position: Coordinate
    
    init(lines: [Line], goal: Goal, position: Coordinate) {
        self.lines = lines
        self.goal = goal
        self.position = position
    }
}

struct Goal: Codable {
    let origin: Coordinate
    let outpost: Coordinate
    
    func flatten(onto plane: Plane) -> CGRect {
        let standard = FlatLine(start: origin.flatten(onto: plane), end: outpost.flatten(onto: plane)).standardize()
        return CGRect(x: standard.start.x, y: standard.start.y, width: standard.end.x - standard.start.x, height: standard.end.y - standard.start.y)
    }
}

struct Line: Hashable, Codable {
    static func == (lhs: Line, rhs: Line) -> Bool {
        if lhs.start == rhs.start && lhs.end == rhs.end {
            return true
        }
        return false
    }
    
    let start: Coordinate
    let end: Coordinate
    
    init(start: Coordinate, end: Coordinate) {
        self.start = start
        self.end = end
    }
    
    func flatten(onto plane: Plane) -> FlatLine {
        return FlatLine(start: start.flatten(onto: plane), end: end.flatten(onto: plane))
    }
}

struct FlatLine: Hashable {
    let start: CGPoint
    let end: CGPoint
    
    init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
    }
    
    static func +(lhs: FlatLine, rhs: FlatLine) -> FlatLine {
        return FlatLine(start: CGPoint(x: lhs.start.x + rhs.start.x, y: lhs.start.y + rhs.start.y), end: CGPoint(x: lhs.end.x + rhs.end.x, y: lhs.end.y + rhs.end.y))
    }
    
    static func +(lhs: FlatLine, rhs: CGPoint) -> FlatLine {
        return FlatLine(start: CGPoint(x: lhs.start.x + rhs.x, y: lhs.start.y + rhs.y), end: CGPoint(x: lhs.end.x + rhs.x, y: lhs.end.y + rhs.y))
    }
    
    static func -(lhs: FlatLine, rhs: FlatLine) -> FlatLine {
        return FlatLine(start: CGPoint(x: lhs.start.x - rhs.start.x, y: lhs.start.y - rhs.start.y), end: CGPoint(x: lhs.end.x - rhs.end.x, y: lhs.end.y - rhs.end.y))
    }
    
    static func -(lhs: FlatLine, rhs: CGPoint) -> FlatLine {
        return FlatLine(start: CGPoint(x: lhs.start.x - rhs.x, y: lhs.start.y - rhs.y), end: CGPoint(x: lhs.end.x - rhs.x, y: lhs.end.y - rhs.y))
    }
    
    static func /(lhs: FlatLine, rhs: CGFloat) -> FlatLine {
        return FlatLine(start: CGPoint(x: lhs.start.x / rhs, y: lhs.start.y / rhs), end: CGPoint(x: lhs.end.x / rhs, y: lhs.end.y / rhs))
    }
    
    static func *(lhs: FlatLine, rhs: CGFloat) -> FlatLine {
        return FlatLine(start: CGPoint(x: lhs.start.x * rhs, y: lhs.start.y * rhs), end: CGPoint(x: lhs.end.x * rhs, y: lhs.end.y * rhs))
    }
    
    static func *(lhs: FlatLine, rhs: CGPoint) -> FlatLine {
        return FlatLine(start: CGPoint(x: lhs.start.x * rhs.x, y: lhs.start.y * rhs.y), end: CGPoint(x: lhs.end.x * rhs.x, y: lhs.end.y * rhs.y))
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(start.x)
        hasher.combine(end.y)
    }
    
    func getPath() -> CGPath {
        let path = CGMutablePath()
        path.move(to: start)
        path.addLine(to: end)
        path.closeSubpath()
        return path
    }
    
    func standardize() -> FlatLine {
        if start.x > end.x {
            return FlatLine(start: end, end: start)
        }
        else if start.x == end.x {
            if start.y > end.y {
                return FlatLine(start: end, end: start)
            }
        }
        return FlatLine(start: start, end: end)
    }
}

struct Coordinate: Hashable, Codable {
    var x: CGFloat
    var y: CGFloat
    var z: CGFloat
    
    init(x: CGFloat, y: CGFloat, z: CGFloat) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    func flatten(onto plane: Plane) -> CGPoint {
        switch plane {
        case .XY:
            return CGPoint(x: x, y: y)
        case .XZ:
            return CGPoint(x: x, y: z)
        case .ZY:
            return CGPoint(x: z, y: y)
        }
    }
}

enum Plane {
    case XY
    case ZY
    case XZ
}
