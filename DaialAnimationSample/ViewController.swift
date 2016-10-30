//
//  ViewController.swift
//  DaialAnimationSample
//
//  Created by Masanori Kuze on 2016/10/30.
//  Copyright © 2016年 Masanori Kuze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var subLayer : DaialLayer!
    
    var _centerPoint : CGPoint = CGPoint(x: 200, y: 250)
    var _radius : CGFloat! = 0
    var _previousPoint: CGPoint!
    var _orignalRadius : CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        subLayer = DaialLayer()
         subLayer.frame = CGRect(x: 100, y: 150, width: 200, height: 200)
        
        self.view.layer.addSublayer(subLayer)
        subLayer.setNeedsDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : UITouch = touches.first! as UITouch
        let startPoint = touch.location(in: self.view)
        NSLog("start = %f, %f", startPoint.x, startPoint.y)
        
        for layer in self.view.layer.sublayers!{
            if let tapLayer = layer.hitTest(startPoint) {
                
                if(tapLayer is DaialLayer) {
                    _previousPoint = startPoint
                    _radius = getHypotenuse(_centerPoint, point2: startPoint)
                }
            }
        }
        //        rotate(point: startPoint, fin: false)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : UITouch = touches.first! as UITouch
        let startPoint = touch.location(in: self.view)
        //        NSLog("moved ")
        
        for layer in self.view.layer.sublayers!{
            if let tapLayer = layer.hitTest(startPoint) {
                
                if(tapLayer is DaialLayer) {
                    rotate(startPoint, fin: false)
                }
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : UITouch = touches.first! as UITouch
        let startPoint = touch.location(in: self.view)
        NSLog("last= %f, %f", startPoint.x, startPoint.y)
        
        for layer in self.view.layer.sublayers!{
            if let tapLayer = layer.hitTest(startPoint) {
                
                if(tapLayer is DaialLayer) {
                    rotate(startPoint, fin: false)
                }
            }
        }

     }
    
    //回転演出
    func rotate(_ point : CGPoint, fin : Bool) {
        //斜辺の長さを算出（半径）
        let radius = getHypotenuse(_centerPoint, point2: point)
        //最初の半径とtmpの半径の比率
        let hiritu = radius / _radius
        //最初のポイントがある円周上にpointの座標を比率で割ったものをセット
        let tmpPoint = CGPoint(x: (point.x * hiritu), y: (point.y * hiritu))
        //前回と今回のポイントの距離（斜辺）を算出して対象の円周上で作った斜辺に比率を直す
        let base = getHypotenuse(_previousPoint, point2: tmpPoint) * (_radius/_orignalRadius)
        
        if(base != 0){
            //sinの計算でラジアンを算出
            let radian = (sin((1/_orignalRadius)*(base/2)) * CGFloat(180/M_PI) * 2) * CGFloat(M_PI / 180)
            
            if(radian > 0) {
                //アニメーション
                rotateAnimeation(radian, fin: fin)
             }
        }
        
        _previousPoint = point
        _radius = getHypotenuse(_centerPoint, point2: point)
    }
    
    
    //斜辺算出
    func getHypotenuse(_ point1 : CGPoint, point2 : CGPoint) -> CGFloat {
        let  radius = CGFloat(sqrt(pow(abs(Double(point2.x - point1.x)), 2) + pow(abs(Double(point2.y - point1.y)),2)))
        
        return radius
    }
    
    //アニメーション
    func rotateAnimeation(_ angle : CGFloat, fin: Bool = false) {
        
//        let interval = fin ? 0 : 1 * Double(angle) * Double(180 / M_PI)
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
//        CATransaction.setValue(interval, forKey: kCATransactionAnimationDuration)
        
        let myRotationAngle : CGFloat = angle
//        let myRotationAngle : CGFloat = CGFloat(1/60 * M_PI)
        let myRotationTransform : CATransform3D = CATransform3DRotate(subLayer.transform, myRotationAngle, 0.0, 0.0, 1.0)
        subLayer.transform = myRotationTransform;
        
        CATransaction.commit()
    }
    
}

