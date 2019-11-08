//
//  BadSugar.swift
//  Demo001
//
//  Created by Francis Jemuel Bergonia on 11/8/19.
//  Copyright © 2019 Arkray Marketing, Inc. All rights reserved.
//

import UIKit
import SceneKit

class BadSugar: SCNNode {
    override init() {
        super.init()
        let box = SCNBox(width: 0.9, height: 0.9, length: 0.9, chamferRadius: 0)
        self.geometry = box
        let shape = SCNPhysicsShape(geometry: box, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        // add texture
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "galaxy")
        self.geometry?.materials  = [material, material, material, material, material, material]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
