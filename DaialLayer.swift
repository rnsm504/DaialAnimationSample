//
//  DaialLayer.swift
//  DaialAnimationSample
//
//  Created by Masanori Kuze on 2016/10/30.
//  Copyright © 2016年 Masanori Kuze. All rights reserved.
//

import UIKit

class DaialLayer : CAShapeLayer {
    
    var onLight : Bool = true
    fileprivate var count : Int = 1
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in ctx: CGContext) {
        //背景
        let c = UIColor.white
        ctx.setFillColor(c.cgColor)
        ctx.addRect(self.bounds)
        ctx.drawPath(using: .fill)
        
        var cc = UIColor.gray
        
        let block : Int = 30
        let blank : Int = 10
        var cnt : Int = 0
        
        for i in 0 ..< 360 {
            if(i%(block+blank)==0){
                if(cnt == count && onLight){
                    cc = UIColor.orange
                    onLight = !onLight
                } else {
                    cc = UIColor.gray
                }
                cnt += 1
                let angle = CGFloat(i)
                ctx.move(to: CGPoint(x: self.bounds.midX, y: self.bounds.midY))
                let sa : CGFloat = angle * CGFloat(M_PI/180)
                let ea : CGFloat = ((angle + CGFloat(block-1)) * CGFloat(M_PI/180))
                
                ctx.addArc(center: CGPoint(x:self.bounds.midX, y:self.bounds.midY), radius: 100, startAngle: sa, endAngle: ea, clockwise: false)
                ctx.closePath()
                ctx.setFillColor(cc.cgColor)
                ctx.drawPath(using: .fill)
            }
        }
        
        //center circle
        ctx.addArc(center: CGPoint(x:self.bounds.midX, y:self.bounds.midY), radius: 50, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: false)
        ctx.closePath()
        ctx.setFillColor(c.cgColor)
        ctx.drawPath(using: .fill)
    }
    
}

