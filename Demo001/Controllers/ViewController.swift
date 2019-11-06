//
//  ViewController.swift
//  Demo001
//
//  Created by Francis Jemuel Bergonia on 11/5/19.
//  Copyright © 2019 Arkray Marketing, Inc. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Show scene debug options
        sceneView.debugOptions = [.showFeaturePoints]
        
        // Add lightSouce or make scene 3D enabled
        sceneView.automaticallyUpdatesLighting = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        //sceneView.scene = scene
        self.addCubes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    private func addCubes() {
        
        // initialize Cube
        let cube = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        cube.materials = [material]
        
        // set node
        let cubeNode = SCNNode()
        cubeNode.geometry = cube
        cubeNode.position = SCNVector3(0.0, 0.0, -3.0)
        
        // add action
        let rotation = SCNAction.rotateBy(x: 0.0, y: 2 * .pi, z: 0, duration: 2)
        let repeatRotation = SCNAction.repeatForever(rotation)
        cubeNode.runAction(repeatRotation)
        
        // set the cube to the view
        sceneView.scene.rootNode.addChildNode(cubeNode)
        
    }

}
