//
//  CubesViewController.swift
//  Demo001
//
//  Created by Francis Jemuel Bergonia on 11/6/19.
//  Copyright © 2019 Arkray Marketing, Inc. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class CubesViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var minHeight : CGFloat = 0.2
    var maxHeight : CGFloat = 0.6
    var minDispersal : CGFloat = -4
    var maxDispersal : CGFloat = 4
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    
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
    
    private func generateCube() {
        let s = generateRandomSize()
        let cube = SCNBox(width: s, height: s, length: s, chamferRadius: 0.03)
        cube.materials.first?.diffuse.contents = generateRandomColor()
        
        let cubeNode = SCNNode(geometry: cube)
        cubeNode.position = generateRandomVector()
        let rotateAction = SCNAction.rotateBy(x: .pi, y: 2 * .pi, z: 0, duration: 3)
        let repeatAction = SCNAction.repeatForever(rotateAction)
        
        cubeNode.runAction(repeatAction)
        
        sceneView.scene.rootNode.addChildNode(cubeNode)
    }
    
    @IBAction func addCubeClicked(_ sender: Any) {
        generateCube()
    }
    
}
