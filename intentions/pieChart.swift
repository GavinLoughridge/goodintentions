//
//  pieChart.swift
//  intentions
//
//  Created by Gavin Loughridge on 11/23/17.
//  Copyright © 2017 Gavin Loughridge. All rights reserved.
//

import UIKit

func pieChart(center: CGPoint, radius: Int, color: CGColor, value: Float) -> CAShapeLayer {
    
    let shapeLayer = CAShapeLayer()
    
    if value == 0 {
        return shapeLayer
    }
    
    let startAngle = CGFloat(.pi * (3.0 / 2.0))
    let endAngle = CGFloat(.pi * (3.0 / 2.0 - 2.0 * value))
    
    let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(radius / 2), startAngle: startAngle, endAngle: endAngle, clockwise: false)
    
    
    shapeLayer.path = circlePath.cgPath
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = color
    shapeLayer.lineWidth = CGFloat(radius)
    
    return shapeLayer
}
