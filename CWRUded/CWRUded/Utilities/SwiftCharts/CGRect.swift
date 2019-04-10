//
//  CGRect.swift
//  ChartLegends
//
//  Created by Ivan Schuetz on 02/01/2017.
//  Copyright © 2017 Ivan Schuetz. All rights reserved.
//

import UIKit

extension CGRect {

    var center: CGPoint {
        return CGPoint(x: minX + width / 2, y: minY + height / 2)
    }
    
    public func insetBy(dx: CGFloat = 0, dy: CGFloat = 0, dw: CGFloat = 0, dh: CGFloat = 0) -> CGRect {
        return CGRect(
            x: origin.x + dx,
            y: origin.y + dy,
            width: width - dw - dx,
            height: height - dh - dy
        )
    }
    
    func asLinesArray() -> [(p1: CGPoint, p2: CGPoint)] {
        return [
            (p1: CGPoint(x: minX, y: minY), p2: CGPoint(x: maxX, y: minY)),
            (p1: CGPoint(x: maxX, y: minY), p2: CGPoint(x: maxX, y: maxY)),
            (p1: CGPoint(x: maxX, y: maxY), p2: CGPoint(x: minX, y: maxY)),
            (p1: CGPoint(x: minX, y: maxY), p2: CGPoint(x: minX, y: minY))
        ]
    }    
    
    /**
     Calculates the bounding rectangle of a rectangle after it's rotated.
     
     Source: http://stackoverflow.com/a/9168238/930450
     
     - parameter radians: The angle in radians that it's to be rotated
     
     - returns: The bounding rectangle of the rotated rectangle
     */
    public func boundingRectAfterRotating(radians: CGFloat) -> CGRect {
        return applying(CGAffineTransform(rotationAngle: radians))
    }
    
}
