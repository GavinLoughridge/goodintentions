//
//  progressChart.swift
//  intentions
//
//  Created by Gavin Loughridge on 11/23/17.
//  Copyright © 2017 Gavin Loughridge. All rights reserved.
//

import UIKit

class progressChart: UIView {
    
    //Mark: Properties
    
    @IBInspectable var chartValue: Float = Float(0) {
        didSet {
            setupChart()
        }
    }
    
    //Mark: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChart()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        setupChart()
    }
    
    private func setupChart() {
        let chartColor = UIColor(red: 142 / 255, green: 208 / 255, blue: 129 / 255, alpha: 1)
        
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let width = self.layer.frame.size.width
        
        let shapeLayer = pieChart(center: CGPoint(x: width / 2, y: width / 2), radius: Int(width / 2), color: chartColor.cgColor, value: chartValue)
        
        shapeLayer.frame = self.layer.bounds
        
        self.layer.addSublayer(shapeLayer)
        
    }
}
