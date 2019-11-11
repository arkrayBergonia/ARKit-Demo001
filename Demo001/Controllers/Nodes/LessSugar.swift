//
//  LessSugar.swift
//  Demo001
//
//  Created by Francis Jemuel Bergonia on 11/8/19.
//  Copyright © 2019 Arkray Marketing, Inc. All rights reserved.
//

import UIKit
import SceneKit

class LessSugar: SCNNode {
    
    let infoVC = InfoViewController()
    
    // for sugarCubes
    var minHeight : CGFloat = 0.5
    var maxHeight : CGFloat = 0.9
    var minDispersal : CGFloat = -4
    var maxDispersal : CGFloat = 4
    
    override init() {
        super.init()
        let s = generateRandomSize()
        
        let box = SCNBox(width: s, height: s, length: s, chamferRadius: 0.03)
        self.geometry = box
        let shape = SCNPhysicsShape(geometry: box, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        // add texture
        let imageName = Entities().targetAllotted(for: self.infoVC.currentRoundInfo)
        let image = UIImage(named: "donut")
        let material = SCNMaterial()
        material.diffuse.contents = image //generateRandomColor()
        self.geometry?.materials  = [material, material, material, material]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LessSugar {
    private func generateRandomVector() -> SCNVector3 {
        return SCNVector3(CGFloat.random(in: minDispersal ... maxDispersal),
                          CGFloat.random(in: minDispersal ... maxDispersal),
                          CGFloat.random(in: minDispersal ... maxDispersal))
    }
    
    private func generateRandomColor() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0 ... 1),
                       green: CGFloat.random(in: 0 ... 1),
                       blue: CGFloat.random(in: 0 ... 1),
                       alpha: CGFloat.random(in: 0.5 ... 1))
    }
    
    private func generateRandomSize() -> CGFloat {
        return CGFloat.random(in: minHeight ... maxHeight)
    }
}
