//
//  BadSugarGameViewController.swift
//  Demo001
//
//  Created by Francis Jemuel Bergonia on 11/6/19.
//  Copyright © 2019 Xi Apps, Inc. All rights reserved.
//

//Tutorial from: https://medium.com/libertyit

import UIKit
import SceneKit
import ARKit

struct CollisionCategory: OptionSet {
    let rawValue: Int
    
    static let missileCategory  = CollisionCategory(rawValue: 1 << 0)
    static let targetCategory = CollisionCategory(rawValue: 1 << 1)
    static let otherCategory = CollisionCategory(rawValue: 1 << 2)
}

class BadSugarGameViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {
    
    //MARK: - variables
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    let infoVC = InfoViewController()
    let defaults = UserDefaults.standard
    
    var score = 0 //used to store the score
    var seconds = 60 //to store how many sceonds the game is played for
    var timer = Timer() //timer
    var player: AVAudioPlayer? // Sound Player
    var isTimerRunning = false //to keep track of whether the timer is on
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        //set the physics delegate
        sceneView.scene.physicsWorld.contactDelegate = self
        
        //add objects to shoot at
        addTargetNodes()
        
        //play background music
        playBackgroundMusic()
        
        //start tinmer
        runTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        self.seconds = Entities().timeAllotted(for: self.infoVC.currentRoundInfo)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //shooter button
    @IBAction func onAxeButton(_ sender: Any) {
        self.fireMissile()
    }
    
}

// MARK: - timer
extension BadSugarGameViewController {
    //to run the timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    //decrements seconds by 1, updates the timerLabel and calls gameOver if seconds is 0
    @objc func updateTimer() {
        if seconds == 0 {
            timer.invalidate()
            if score < Entities().targetScore(for: self.infoVC.currentRoundInfo) {
                self.defaults.set(true, forKey: "gameOver")
            }
            
            gameOver()
        }else{
            seconds -= 1
            timerLabel.text = "\(seconds) s"
        }
    }
    
    //resets the timer
    func resetTimer(){
        timer.invalidate()
        seconds = 60
        timerLabel.text = "\(seconds) s"
    }
    
    // MARK: - game over
    func gameOver(){
        //store the score in UserDefaults
        self.defaults.set(score, forKey: "score")
        self.score = 0
        //go back to the Home View Controller
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - missiles & targets
extension BadSugarGameViewController {
    
    //creates banana or axe node and 'fires' it
    func fireMissile() {
        var node = SCNNode()
        //create node
        node = createMissile()
        
        //get the users position and direction
        let (direction, position) = self.getUserVector()
        node.position = position
        var nodeDirection = SCNVector3()
        
        nodeDirection  = SCNVector3(direction.x*4,direction.y*4,direction.z*4)
        node.physicsBody?.applyForce(SCNVector3(direction.x,direction.y,direction.z), at: SCNVector3(0,0,0.1), asImpulse: true)
        playSound(sound: "torpedo", format: "mp3")
        
        
        //move node
        node.physicsBody?.applyForce(nodeDirection , asImpulse: true)
        
        //add node to scene
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    //creates nodes
    func createMissile()->SCNNode{
        let node = Bullet()  //SCNNode()
        node.name = "bathtub"
        
        //the physics body governs how the object interacts with other objects and its environment
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node.physicsBody?.isAffectedByGravity = false
        
        //these bitmasks used to define "collisions" with other objects
        node.physicsBody?.categoryBitMask = CollisionCategory.missileCategory.rawValue
        node.physicsBody?.collisionBitMask = CollisionCategory.targetCategory.rawValue
        return node
    }
}

// MARK: - populate with 3D objects
extension BadSugarGameViewController {
    //MARK: - maths
    func getUserVector() -> (SCNVector3, SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    
    //Adds 100 objects to the scene, spins them, and places them at random positions around the player.
    func addTargetNodes(){
        for index in 1...100 {
            
            var node = SCNNode()
            
            if (index > 9) && (index % 10 == 0) {
                node = BadSugar()
                node.name = "Bad Sugar"
            }else{
                node = LessSugar() //SCNNode(geometry: cube)
                node.name = "cube"
            }
            
            node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            node.physicsBody?.isAffectedByGravity = false
            
            //place randomly, within thresholds
            node.position = SCNVector3(randomFloat(min: -10, max: 10),randomFloat(min: -4, max: 5),randomFloat(min: -10, max: 10))
            
            //rotate
            let action : SCNAction = SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 1.0)
            let forever = SCNAction.repeatForever(action)
            node.runAction(forever)
            
            //for the collision detection
            node.physicsBody?.categoryBitMask = CollisionCategory.targetCategory.rawValue
            node.physicsBody?.contactTestBitMask = CollisionCategory.missileCategory.rawValue
            
            //add to scene
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    //create random float between specified ranges
    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
}


// MARK: - Contact Delegate
extension BadSugarGameViewController {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        print("** Collision!! " + contact.nodeA.name! + " hit " + contact.nodeB.name!)
        
        if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.targetCategory.rawValue
            || contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.targetCategory.rawValue {
            
            if (contact.nodeA.name! == "Bad Sugar" || contact.nodeB.name! == "Bad Sugar") {
                score+=5
            }else{
                score+=1
            }
            
            DispatchQueue.main.async {
                contact.nodeA.removeFromParentNode()
                contact.nodeB.removeFromParentNode()
                self.scoreLabel.text = String(self.score)
            }
            
            playSound(sound: "explosion", format: "wav")
            let  explosion = SCNParticleSystem(named: "Explode", inDirectory: nil)
            contact.nodeB.addParticleSystem(explosion!)
        }
    }
}

// MARK: - sounds
extension BadSugarGameViewController {
    func playSound(sound : String, format: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: format) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playBackgroundMusic(){
        let audioNode = SCNNode()
        let audioSource = SCNAudioSource(fileNamed: "overtake.mp3")!
        let audioPlayer = SCNAudioPlayer(source: audioSource)
        
        audioNode.addAudioPlayer(audioPlayer)
        
        let play = SCNAction.playAudio(audioSource, waitForCompletion: true)
        audioNode.runAction(play)
        sceneView.scene.rootNode.addChildNode(audioNode)
    }
}
